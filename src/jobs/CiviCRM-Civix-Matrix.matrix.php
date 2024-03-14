<?php

/**
 * @see \UpdateMatrices\buildMatrix()
 */
return [
  // Based on 'branches.yaml', construct CIVIVER x BLDTYPE x BKPROF
  'branches' => ['dev', 'esr0', 'esr2'],
  'filter' => function(array $item): bool {
    // Not ready to start testing standalone yet
    if (preg_match('/^standalone/', $item['BLDTYPE'])) {
      return FALSE;
    }

    // Test every supported variant on master
    if ($item['CIVIVER'] === 'master') {
      return TRUE;
    }

    if (preg_match(';^(drupal|drupal9|wp)-;', $item['BLDTYPE'])) {
      return in_array($item['#bkProfRole'], ['min']);
    }
    elseif (preg_match(';^(drupal10|standalone|backdrop)-;', $item['BLDTYPE'])) {
      return in_array($item['#bkProfRole'], ['max']);
    }

    return FALSE;
  }
];
