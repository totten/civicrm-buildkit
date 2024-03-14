/* Auto-generated from CiviCRM-Civix-Matrix.matrix.php via update-matrices.php */

String signature(Map item, List keys) {
    def sig = ''
    keys.each { key ->
        sig += '\u0000' + "${item[key]}"
    }
    return sig
}

def expectedItems = [
  [CIVIVER: 'master', BLDTYPE: 'backdrop-clean', BKPROF: 'php74m57'],
  [CIVIVER: 'master', BLDTYPE: 'backdrop-clean', BKPROF: 'php82m80'],
  [CIVIVER: 'master', BLDTYPE: 'drupal-clean', BKPROF: 'php74m57'],
  [CIVIVER: 'master', BLDTYPE: 'drupal-clean', BKPROF: 'php82m80'],
  [CIVIVER: 'master', BLDTYPE: 'drupal-clean', BKPROF: 'php83m80'],
  [CIVIVER: 'master', BLDTYPE: 'drupal9-clean', BKPROF: 'php74m57'],
  [CIVIVER: 'master', BLDTYPE: 'drupal9-clean', BKPROF: 'php81m80'],
  [CIVIVER: 'master', BLDTYPE: 'drupal10-clean', BKPROF: 'php81m57'],
  [CIVIVER: 'master', BLDTYPE: 'drupal10-clean', BKPROF: 'php82m80'],
  [CIVIVER: 'master', BLDTYPE: 'wp-demo', BKPROF: 'php74m57'],
  [CIVIVER: 'master', BLDTYPE: 'wp-demo', BKPROF: 'php82m80'],
  [CIVIVER: '5.69', BLDTYPE: 'backdrop-clean', BKPROF: 'php81m80'],
  [CIVIVER: '5.69', BLDTYPE: 'drupal-clean', BKPROF: 'php73m57'],
  [CIVIVER: '5.69', BLDTYPE: 'drupal9-clean', BKPROF: 'php74m57'],
  [CIVIVER: '5.69', BLDTYPE: 'drupal10-clean', BKPROF: 'php81m80'],
  [CIVIVER: '5.69', BLDTYPE: 'wp-demo', BKPROF: 'php73m57'],
  [CIVIVER: '5.57', BLDTYPE: 'backdrop-clean', BKPROF: 'php81m80'],
  [CIVIVER: '5.57', BLDTYPE: 'drupal-clean', BKPROF: 'php73m57'],
  [CIVIVER: '5.57', BLDTYPE: 'drupal9-clean', BKPROF: 'php74m57'],
  [CIVIVER: '5.57', BLDTYPE: 'wp-demo', BKPROF: 'php73m57'],
]

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