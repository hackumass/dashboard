function autoFormatPhoneNum(){var e=document.getElementById("phone"),n=e.value,t=e.selectionStart,o=e.selectionEnd;if(n.length>=10&&8==event.keyCode)switch(o){case 1:t=0,o=0;break;case 2:t=1,o=1;break;case 3:t=2,o=2;break;case 6:t=3,o=3;break;case 7:t=4,o=4;break;case 8:t=5,o=5;break;case 10:t=6,o=6;break;case 11:t=7,o=7;break;case 12:t=8,o=8;break;case 13:case 14:t=9,o=9}if(n=n.split(new RegExp("[-()\\s]","g")).join(""),37!=event.keyCode&&39!=event.keyCode)if(10==n.length){var c=n.substring(0,3);c="(".concat(c).concat(") ");var a="";n.length>=3&&(a=n.substring(3),a.length>=3&&(a=a.match(new RegExp(".{1,4}$|.{1,3}","g")).join("-"))),n=c+a,$(e).val(n),14==o||event.ctrlKey||(t=14,o=14)}else $(e).val(n);e.setSelectionRange(t,o)}function charCounter(e,n){var t=document.getElementById(e),o=document.getElementById(n);if(null!=t&&null!=o){var c=t.value.length,a=o.innerHTML.indexOf("of"),d=o.innerHTML.substring(a);o.innerHTML=c+" "+d}}function unhideField(e){document.getElementById(e).style.display="block"}function hideField(e){document.getElementById(e).style.display="none"}function togglehiddenField(e,n){checkBox=document.getElementById(n),null!=checkBox&&checkBox.checked?unhideField(e):hideField(e)}$(document).ready(function(){charCounter("text-box","char-counter"),charCounter("text-box-2","char-counter-2"),charCounter("text-box-3","char-counter-3"),togglehiddenField("food-info","foodRadios1"),togglehiddenField("transport-info","transportRadios1"),togglehiddenField("hardware-hack-list","hardware-radio-1"),unhideField("char-counter"),unhideField("char-counter-2"),unhideField("char-counter-3")});