int SlotNumber(DateTime time){

  // 20-25min ka playtime duration per slot
  // 1:00 - 1:45 tak ek slot accessible rahega

  if (time.minute > 45)
    return -1;  // Change UI => Next Slot will be available soon
  else{
    switch(time.hour){
      case 13 : return 1;
      case 14 : return 2;
      case 15 : return 3;
    }
  }
  return 0;   // Change UI => Either even is over OR Event is yet to start
}