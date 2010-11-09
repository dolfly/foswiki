function wikify(sourceId, targetId, suffix) {

  var source = document.getElementById(sourceId);
  var target = document.getElementById(targetId);
  if (!source || !target) {
    return;
  }
  target.value = wikifyString(source.value, suffix);
}

function wikifyString(value, suffix) {
  value = value.replace(/ä/g, "ae");
  value = value.replace(/ö/g, "oe");
  value = value.replace(/ü/g, "ue");
  value = value.replace(/Ä/g, "Ae");
  value = value.replace(/Ö/g, "Oe");
  value = value.replace(/Ü/g, "Ue");
  value = value.replace(/ß/g, "ss");
  value = value.replace(/[a-zA-Z\d]+/g, function(a) {
      return a.charAt(0).toLocaleUpperCase() + a.substr(1);
  });
  value = value.replace(/[^a-zA-Z\d]/g, "");
  value = value.replace(/\s/g, "");
  if (suffix) {
    value += suffix;
  }
  return value;
}
