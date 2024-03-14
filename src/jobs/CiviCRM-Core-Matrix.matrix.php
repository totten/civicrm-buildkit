<?php

/**
 * @see \UpdateMatrices\buildMatrix()
 */
return [
  'branches' => ['dev', 'rc', 'stable', 'esr0'],
  'suites' => [
    'phpunit-api3',
    'phpunit-api4',
    'phpunit-civi',
    'phpunit-core-exts',
    'phpunit-crm',
    'phpunit-e2e',
    'meta-oddball', /* upgrade + karma + mixin */
  ],
  'filter' => function(array $item): bool {
    $isStable = (bool) preg_match(';^(stable|esr);', $item['#branchName']);
    $isEsr = (bool) preg_match(';esr;', $item['#branchName']);

    // Only run 'edge' on 'master'
    if ($item['#bkProfRole'] === 'edge' && $item['CIVIVER'] !== 'master') {
      return FALSE;
    }

    // Allow all permutations involving `drupal-clean`. It's our baseline.
    if ($item['BLDTYPE'] === 'drupal-clean') {
      return TRUE;
    }
    // Everything hereafter speaks to alternative UFs...

    // If the test-suite is expensive and platform-independent, then ignore it.
    $expensiveAndIndependentSuites = ['phpunit-api3', 'phpunit-api4', 'phpunit-crm', 'phpunit-civi'];
    $isExpensiveAndIndependent = in_array($item['SUITES'], $expensiveAndIndependentSuites);
    if ($isExpensiveAndIndependent) {
      return FALSE;
    }

    // D9 and D10 are very similar. We'll split them: Yes for D9@min + D10@max. No for D9@max + D10@min.
    if (str_starts_with($item['BLDTYPE'], 'drupal9-')) {
      return in_array($item['#bkProfRole'], ['min']);
    }
    elseif (str_starts_with($item['BLDTYPE'], 'drupal10-')) {
      return in_array($item['#bkProfRole'], ['max', 'edge']);
    }
    elseif (str_starts_with($item['BLDTYPE'], 'wp-')) {
      return !$isEsr || in_array($item['#bkProfRole'], ['min']);
    }
    else {
      return TRUE;
    }
  },

];
