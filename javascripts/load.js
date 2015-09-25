load = function(/* files..., cb */){
  var args = [].slice.call(arguments);
  var cb = args.pop();
  var num = args.length, ret = {}, numLoaded = 0;

  var loaded = function(file, evt){
    numLoaded++;
    ret[file] = evt.target.response;
    if(numLoaded === num) cb(ret);
  };

  args.forEach(function(it){
    var xhr = new XMLHttpRequest();
    xhr.open('GET', it);
    xhr.addEventListener("load", loaded.bind(this, it), false);
    xhr.send(null);
  });
};