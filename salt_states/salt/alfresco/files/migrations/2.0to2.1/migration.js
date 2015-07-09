var nodes = search.luceneSearch("@sysml\\:documentation:ve.html");
logger.log("Number of elements with ve.html: "+nodes.length);
var regExp1 = new RegExp('<a.*href=.*ve.html#.*/products/([^/"]*)/([^/"\']*)(/view/([^/"\']*))?[^"\']*["|\'][^>]*>([^<]*).*<\/a>','g');

function replacer(match, p1, p2, p3, p4, p5, offset, string) {

  //logger.log([p1,p2,p3,p4,p5].join());
  // If it has a view:
  if (p3) {
    if (p2 !== 'latest') {
        return '<mms-view-link data-mms-did="'+p1+'" data-mms-vid="'+p4+'" data-mms-version="'+p2+'">'+p5+'</mms-view-link>';
    }
    else {
    return '<mms-view-link data-mms-did="'+p1+'" data-mms-vid="'+p4+'">'+p5+'</mms-view-link>';
    }
  }
  else {
    if (p2 !== 'latest') {
        return '<mms-view-link data-mms-did="'+p1+'" data-mms-vid="'+p1+'" data-mms-version="'+p2+'">'+p5+'</mms-view-link>';
    }
    else {
    return '<mms-view-link data-mms-did="'+p1+'" data-mms-vid="'+p1+'">'+p5+'</mms-view-link>';
    }
  }

}

for each(var node in nodes) {
    //logger.log(node.name + " (" + node.typeShort + "): " + node.nodeRef);
  var docStr = node.getProperties()["{http://jpl.nasa.gov/model/sysml-lite/1.0}documentation"];
  
  //docStr = docStr.split("\n")[4];
    logger.log("docStr= "+docStr+"\n\n\n");
var docStrNew = docStr.replace(regExp1, replacer);
 
    logger.log("docStrNew= "+docStrNew+"\n\n\n");
    
  // Replace w/ new doc string:
//node.getProperties()["{http://jpl.nasa.gov/model/sysml-lite/1.0}documentation"] = docStrNew;
//node.save();
}

////////

nodes = search.luceneSearch("@sysml\\:documentation:docweb.html");
logger.log("Number of elements with docweb.html: "+nodes.length);
regExp1 = new RegExp('(.*)docweb(.*)/sites/([^/]*)(/config/([^"\']*))?','g');

function replacer2(match, p1, p2, p3, p4, p5, offset, string) {

  //logger.log([p1,p2,p3,p4,p5].join());
  var str = p1+'mms'+p2+'/sites/'+p3;
  if (p5) {
    str = str+'?tag='+p5;
  }
  return str;

}

for each(var node in nodes) {
    //logger.log(node.name + " (" + node.typeShort + "): " + node.nodeRef);
  var docStr = node.getProperties()["{http://jpl.nasa.gov/model/sysml-lite/1.0}documentation"];
  
  //docStr = docStr.split("\n")[4];
    logger.log("docStr= "+docStr+"\n\n\n");
var docStrNew = docStr.replace(regExp1, replacer2);
 
    logger.log("docStrNew= "+docStrNew+"\n\n\n");
    
  // Replace w/ new doc string:
//node.getProperties()["{http://jpl.nasa.gov/model/sysml-lite/1.0}documentation"] = docStrNew;
//node.save();
}
