int SlotNumber(DateTime time){

  if (time.minute > 45)
    return -1;
  else{
    switch(time.hour){
      case 13 : return 1;
      case 14 : return 2;
      case 15 : return 3;
    }
  }
  return 0;
}