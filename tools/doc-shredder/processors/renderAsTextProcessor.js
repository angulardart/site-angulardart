module.exports = function renderAsTextProcessor() {
  return {
    $runAfter: ['readFilesProcessor'],
    $runBefore: ['writing-files'],
    $process: function(docs) {
      return docs.map(function(doc) {
        var fileInfo = doc.fileInfo;
        doc.renderedContent = doc.content;
        var regionSuffix =  (doc.regionName && doc.regionName.length) ? "-" + doc.regionName.trim() : "";
        var origName = fileInfo.baseName + "." + fileInfo.extension;

        var newName = fileInfo.baseName + regionSuffix +  "." + fileInfo.extension + ".txt";
        doc.outputPath = fileInfo.relativePath.replace(origName, newName);
        return doc;
      })
    }
  };
};