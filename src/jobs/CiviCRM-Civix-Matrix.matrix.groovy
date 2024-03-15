/* Auto-generated from CiviCRM-Civix-Matrix.matrix.php via update-matrices.php */

// import groovy.yaml.YamlSlurper
// import groovy.json.JsonSlurper

String signature(Map item, List keys) {
    def sig = ''
    keys.each { key ->
        sig += '\u0000' + "${item[key]}"
    }
    return sig
}

def dataFile = new File("${WORKSPACE}/src/jobs/CiviCRM-Civix-Matrix.json")
def dataSlurper = new groovy.json.JsonSlurper()
def data = dataSlurper.parseText(dataFile.text)
def expectedItems = data.permutations

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