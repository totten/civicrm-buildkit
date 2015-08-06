#!/usr/bin/env php
<?php

$g = new Ghicu();
$g->main($argv);

/**
 * Github Issue Comments - Updater
 *
 * This will "create or update" a comment on an issue or pull-request.
 *
 * Gaaah. Comment updating is broken in php-github-api. Easier to just write anew.
 */
class Ghicu {
  protected $user, $repoOwner, $repoName, $issueNumber, $message, $github;

  public function parseOptions($argv) {
    foreach (array('GHICU_TOKEN', 'GHICU_USER') as $key) {
      $value = getenv($key);
      if (empty($value) || !preg_match('/^[a-zA-Z0-9_-]+$/', $value)) {
        $this->usage();
        echo "Missing or malformed environment variable ($key)\n";
        exit(1);
      }
    }

    $this->github = new GhicuGithub(getenv('GHICU_TOKEN'));
    $this->user = getenv('GHICU_USER');

    if (isset($argv[1]) && preg_match(':^([a-zA-Z0-9_-]+)/([a-zA-Z0-9_-]+)$:', $argv[1], $matches)) {
      $this->repoOwner = $matches[1];
      $this->repoName = $matches[2];
    }
    else {
      $this->usage();
      echo "Missing or malformed repo argument\n";
      exit(1);
    }

    if (isset($argv[2]) && is_numeric($argv[2])) {
      $this->issueNumber = $argv[2];
    }
    else {
      $this->usage();
      echo "Missing or malformed issue number\n";
      exit(1);
    }

    $this->message = $this->cleanMessage(file_get_contents('php://stdin'));
  }

  public function main($argv) {
    $this->parseOptions($argv);
    $comment = $this->findComment($this->issueNumber, $this->user);
    $response = NULL;
    if (empty($comment) && empty($this->message)) {
      echo "No message provided or found.\n";
      return;
    }
    elseif (empty($comment) && !empty($this->message)) {
      echo "Add comment\n";
      $url = sprintf('https://api.github.com/repos/%s/%s/issues/%s/comments', $this->repoOwner, $this->repoName, $this->issueNumber);
      $response = $this->github->request('POST', $url, array(
        'body' => $this->message,
      ));
    }
    elseif (!empty($comment) && empty($this->message)) {
      echo "Remove stale comment\n";
      $url = sprintf('https://api.github.com/repos/%s/%s/issues/comments/%s', $this->repoOwner, $this->repoName, $comment['id']);
      $response = $this->github->request('DELETE', $url, array());
    }
    elseif (!empty($comment) && !empty($this->message)) {
      if ($this->cleanMessage($comment['body']) == $this->cleanMessage($this->message)) {
        echo "Comment is up to date\n";
      }
      else {
        echo "Update comment\n";
        $url = sprintf('https://api.github.com/repos/%s/%s/issues/comments/%s', $this->repoOwner, $this->repoName, $comment['id']);
        $response = $this->github->request('PATCH', $url, array(
          'body' => $this->message,
        ));
      }
    }
    print_r($response);
  }

  /**
   * @return NULL|array
   */
  public function findComment($issueNumber, $user) {
    $url = sprintf('https://api.github.com/repos/%s/%s/issues/%s/comments', $this->repoOwner, $this->repoName, $issueNumber);
    $comments = $this->github->request('GET', $url);
    foreach ($comments as $comment) {
      if ($comment['user']['login'] === $user) {
        return $comment;
      }
    }
    return NULL;
  }


  public function usage() {
    echo "summary:\n  Create or update a bot comment on a Github issue or PR\n\n";
    echo "usage:\n  ghicu <repo_owner>/<repo_name> <issue_number>\n\n";
    echo "example:\n  echo Hello world | env GHICU_TOKEN=abcd1234 GHICU_USER=mybot ghicu civicrm/civicrm-core 123\n\n";
  }

  protected function cleanMessage($m) {
    return rtrim($m, " \r\n\t");
  }
}

class GhicuGithub {
  protected $token;

  public function __construct($token) {
    $this->token = $token;
  }

  /**
   * Set a request to GitHub APIv3.
   *
   * @param string $method
   *   GET, POST, PATCH.
   * @param $url
   *   Full URL
   * @param null|array $data
   *   Data to send, as an array. (Will be encoded to JSON.)
   * @return mixed
   */
  public function request($method, $url, $data = NULL) {
    $headers = array(
      "Accept: application/vnd.github.v3+json\r\n",
      "Authorization: token {$this->token}\r\n",
    );

    $opts = array(
      'http' => array(
        'method' => $method,
        'user_agent' => 'Ghicu',
      ),
    );

    if ($data !== NULL) {
      $headers[] = "Content-Type: application/json; charset=utf-8\r\n";
      $opts['http']['content'] = json_encode($data);
    }

    $opts['http']['header'] = implode("", $headers);

    $context = stream_context_create($opts);

    return json_decode(file_get_contents($url, FALSE, $context), TRUE);
  }

}
