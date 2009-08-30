@import <eyeos/eyeX.j>
@import <eyeos/server.j>

function main () {
 try{
 //alert('running');
 [eyeX check];
[eyeX message:"Hello world"];
 //alert('exit');
 exit();
 }catch(e) { alert(JSON.stringify(e)); }
}
