#!/usr/bin/env php
<?php

/**
 * Read the *.matrix.php files, which define matrices in our own terminology ("rc", "stable", etc)
 * Write out translated forms in "*.yaml" and "*.groovy" (which are used by Jenkins).
 */

namespace UpdateMatrices;

global $branches;
$branches = yaml_parse_file(__DIR__ . '/branches.yaml')['branches'];

global $comparators;
$comparators['BLDTYPE'] = function($a, $b) {
  global $branches;
  $weights = array_flip(array_keys($branches['dev']['environments']));
  $aw = $weight[$a] ?? 'zzz';
  $bw = $weight[$b] ?? 'zzz';
  if ($aw != $bw) {
    return $bw - $aw;
  }
  return strnatcmp($a, $b);
};
$comparators['CIVIVER'] = function($a, $b) {
  $av = preg_match('/^[\\.0-9]+$/', $a) ? $a : '9999.99.99';
  $bv = preg_match('/^[\\.0-9]+$/', $b) ? $b : '9999.99.99';
  if ($av != $bv) {
    return -1 * version_compare($av, $bv);
  }
  return strnatcmp($a, $b);
};

/**
 * @param array $options
 *  - branches: ['dev', 'rc']
 *  - suites: ['phpunit-e2e', 'phpunit-crm']
 *  - filter: callable
 *     Functions which decides whether to include a specific item/combination
 * @return array
 *   Ex: [['CIVIVER' => '5.69', 'BKPROF' => 'php74m57', 'BLDTYPE' => 'drupal-clean'], ...]
 */
function buildMatrix(array $options): array {
  global $branches;

  $result = [];
  foreach ($options['branches'] as $branchName) {
    $branch = $branches[$branchName];
    foreach ($branch['environments'] as $bldType => $bkProfs) {
      foreach ($bkProfs as $bkProfRole => $bkProf) {
        $item = [
          // Main properties
          'CIVIVER' => $branch['branch'],
          'BLDTYPE' => $bldType,
          'BKPROF' => $bkProf,

          // Extra details for use by filters
          '#branchName' => $branchName,
          '#branch' => $branch,
          '#bkProfRole' => $bkProfRole,
        ];
        $result[] = $item;
      }
    }
  }

  if (isset($options['suites'])) {
    $result = addDimension($result, 'SUITES', $options['suites']);
  }

  if (isset($options['filter'])) {
    $result = array_filter($result, $options['filter']);
  }

  // Filter out hidden properties ("#foo")
  foreach ($result as &$item) {
    foreach (array_keys($item) as $key) {
      if ($key[0] === '#') {
        unset($item[$key]);
      }
    }
  }

  return $result;
}

function addDimension(array $items, string $name, array $values): array {
  $result = [];
  foreach ($items as $item) {
    foreach ($values as $value) {
      $result[] = $item + [$name => $value];
    }
  }
  return $result;
}

function findAxes(array $matrix) {
  global $comparators;
  foreach ($matrix as $first) {
    $keys = array_keys($first);
    break;
  }

  $axes = [];
  foreach ($keys as $key) {
    $axes[$key] = array_unique(array_column($matrix, $key));
    if (isset($comparators[$key])) {
      usort($axes[$key], $comparators[$key]);
    }
    else {
      sort($axes[$key]);
    }
  }

  return $axes;
}

function printMatrix(array $matrix): void {
  foreach ($matrix as $item) {
    printf("%s\n", json_encode($item));
  }
}

function writeYaml(string $file, array $matrix, ?string $comment = NULL): void {
  $buf = '';
  if ($comment !== NULL) {
    $buf .= '# ' . $comment . "\n\n";
  }

  $yaml = findAxes($matrix);
  $yaml['permutation'] = $matrix;

  $buf .= yaml_emit($yaml);
  file_put_contents(__DIR__ . '/' . basename($file), $buf);
}

function writeGroovy(string $file, string $name, array $matrix, ?string $comment = NULL): void {
  $buf = '';
  if ($comment !== NULL) {
    $buf .= implode('', ['/', '* ', $comment, ' *', '/', "\n\n"]);
  }
  $buf .= formatGroovy($name, $matrix);
  file_put_contents(__DIR__ . '/' . basename($file), $buf);
}

function formatGroovyObj(array $item): string {
  $buf = [];
  foreach ($item as $key => $value) {
    if (preg_match(';^[-_\w]+$;', $key) && preg_match(';^[-_\w\\.]*$;', $value)) {
      $buf[] = $key . ': \'' . addslashes($value) . '\'';
    }
    else {
      throw new \RuntimeException("Cannot encode item: $key => $value");
    }
  }
  return '  [' . implode(', ', $buf) . '],';
}

function formatGroovy(string $name, array $matrix): string {
  // $items = implode("\n", array_map(__NAMESPACE__ . '\\formatGroovyObj', $matrix));

  return <<<TEMPLATE
import groovy.yaml.YamlSlurper

String signature(Map item, List keys) {
    def sig = ''
    keys.each { key ->
        sig += '\u0000' + "\${item[key]}"
    }
    return sig
}

def yamlFilePath = "\${WORKSPACE}/src/jobs/$name.yaml"
def yamlFile = new File(yamlFilePath)
def yamlSlurper = new YamlSlurper()
def yamlData = yamlSlurper.parseText(yamlFile.text)
def expectedItems = yamlData.permutations

def keys = expectedItems[0].keySet().toList()
def expectedSignatures = expectedItems.collect { item ->
    signature(item, keys)
}

combinations.each {item ->
  if (expectedSignatures.contains(signature(item, keys))) {
    result.all = result.all ?: []
    result.all << item
  }
}

return result
TEMPLATE;
}

function writeJob(string $name, array $matrix, ?string $comment = NULL): void {
  printf("Generate matrix for %s\n", $name);
  writeYaml("$name.matrix.yaml", $matrix, $comment);
  writeGroovy("$name.matrix.groovy", $name, $matrix, $comment);
}

###############################################################################
###############################################################################

$files = (array) glob(__DIR__ . '/*.matrix.php');
foreach ($files as $file) {
  $name = preg_replace(';\.matrix\.php$;', '', basename($file));
  $options = include $file;
  $comment = sprintf('Auto-generated from %s via %s', basename($file), basename(__FILE__));
  writeJob($name, buildMatrix($options), $comment);
}
