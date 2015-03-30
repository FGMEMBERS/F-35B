# ==============
# TACAN Label
# ==============

tacanLabel = func {
   namestring = getprop("instrumentation/tacan/name");
   if (namestring !=nil) {
      for(i=1; i <= 15 ; i = i+1) {
         if(i <= size(namestring)) { 
            if ( i < 10 ) {
               setprop("instrumentation/tacan/idchars/char_"~chr(i+48),namestring[i-1]);
            }
            else {
               setprop("instrumentation/tacan/idchars/char_1"~chr(i+38),namestring[i-1]);
            }
         }
         else {
            if ( i < 10 ) {
               setprop("instrumentation/tacan/idchars/char_"~chr(i+48),'\ ');
            }
            else {
               setprop("instrumentation/tacan/idchars/char_1"~chr(i+38),'\ ');
            }
         }
      }	
   }
   settimer(tacanLabel, 5.0);
}


settimer(tacanLabel, 1.0);
