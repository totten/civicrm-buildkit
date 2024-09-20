<?php

namespace Loco;

Loco::dispatcher()->addListener('loco.expr.functions', function (LocoEvent $e) {
  /**
   * Generate a strin like `m57' (MySQL 5.7), 'm90' (MySQL 9.0), or 'r105' (MariaDB 10.5).
   */
  $e['functions']['mysql-version-code'] = function () {
    $out = `mysql --no-defaults --version`;
    if (preg_match('/Distrib 5\.7/', $out)) {
      return 'm57';
    }
    elseif (preg_match('/(10\.\d+)\..*-MariaDB/', $out, $m)) {
      return 'r' . str_replace('.', '', $m[1]);
    }
    elseif (preg_match('/Ver ([89]\.\d+)/', $out, $m)) {
      return  'm' . str_replace('.', '', $m[1]);
    }
    else {
      return 'xxx';
    }
  };
});
