/* Auto-generated from CiviCRM-Core-Matrix.matrix.php via update-matrices.php */

import groovy.yaml.YamlSlurper

String signature(Map item, List keys) {
    def sig = ''
    keys.each { key ->
        sig += '\u0000' + "${item[key]}"
    }
    return sig
}

def yamlData = readYaml file: 'src/jobs/CiviCRM-Core-Matrix.yaml'
// def yamlFilePath = "${WORKSPACE}/src/jobs/CiviCRM-Core-Matrix.yaml"
// def yamlFile = new File(yamlFilePath)
// def yamlSlurper = new YamlSlurper()
// def yamlData = yamlSlurper.parseText(yamlFile.text)
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