class event{
  String name;
  float startTime;
  float endTime;
  
  event(String n, String st, int d){
    this.name = n;
    int colon = st.indexOf(":");
    String hour = st.substring(1, colon);
    String minute = st.substring(colon+1);
    if (minute == "30"){
      this.startTime = float(hour) + 0.5;
    }
    else{
      this.startTime = float(hour);
    }
    
    float hr = (d - (d%60))/60;
    float min = d % 60;
    float minutes = float(minute) + min;
    if (minutes > 60){
      minutes %= 60;
      hr++;
    }
    minutes /= 60;
    this.endTime = hr + minutes;
  
  }
  
  void drawEvent(){
    boolean notBooked = checkOverlap();
    //Insert code for calculating ratio
    if (notBooked){
    //Insert code drawing event
    //event time is added to arraylist
    }
  }
    
  boolean checkOverlap(){
    //Insert code ensuring no overlap
  }
  
  
  
  
  
}
