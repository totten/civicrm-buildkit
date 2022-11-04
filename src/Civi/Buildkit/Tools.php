<?php

namespace Civi\Buildkit;

class Tools {

  /**
   * Given a folder like './tools/civicredits', you should:
   * 1. Run "composer install" for its dependencies
   * 2. Add symlinks for "./bin/civicredits" => "./tools/civicredits/bin/civicredits"
   *
   * @param array $task
   *  An enhanced copy of the compilation-task from composer.json. Ex:
   *  - title: "tools/civicredits"
   *  - run: "@php-method \Civi\Buildkit\Tools::install"
   *  - source-file: "/home/user/buildkit/composer.json"
   */
  public static function install(array $task): void {
    $prjDir = dirname($task['source-file']);
    $toolDir = $prjDir . '/' . $task['title'];
    if (!is_dir($toolDir)) {
      throw new \Exception("No such folder: $toolDir");
    }
    chdir($toolDir);
    passthru('composer install', $resultCode);
    if ($resultCode !== 0) {
      throw new \RuntimeException("Failed to install recursive dependencies for $toolDir");
    }
    static::syncBinFiles("$toolDir/bin", "$prjDir/bin");
  }

  protected static function syncBinFiles(string $toolBin, string $prjBin): void {
    $binFiles = (array) glob("$toolBin/*");
    $binFiles = preg_grep('/(\.bak|~)$/', $binFiles, PREG_GREP_INVERT);
    foreach ($binFiles as $binFile) {
      // If this was Windows, you might do it differently...
      static::setSymlink($binFile, $prjBin . '/' . basename($binFile));
    }
  }

  protected static function setSymlink(string $srcFile, string $tgtFile): void {
    if (file_exists($tgtFile)) {
      if (!is_link($tgtFile)) {
        throw new \RuntimeException("Cannot create link $tgtFile. Found conflicting file.");
      }
      elseif (readlink($tgtFile) === $srcFile) {
        return;
      }
      else {
        unlink($tgtFile);
      }
    }
    if (!symlink($srcFile, $tgtFile)) {
      throw new \RuntimeException("Failed to symlink $srcFile => $tgtFile");
    }
  }

}
