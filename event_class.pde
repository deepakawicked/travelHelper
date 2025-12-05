class Event{
  String name;
  float startTime;
  int duration;
  float endTime;
  float hr;
  color colour;
  
  Event(String n, String st, int d){
    this.name = n;
    this.duration = d;
    int colon = st.indexOf(":");
    String hour = st.substring(0, colon);
    String minute = st.substring(colon+1);
    if (float(minute) == 30) this.startTime = float(hour) + 0.5;
    else this.startTime = float(hour);
    
    
    hr = (d - (d%60))/60;
    float min = d % 60;
    float minutes = float(minute) + min;
    if (minutes >= 60){
      minutes %= 60;
      hr++;
    }
    
    minutes /= 60;
    this.endTime = this.startTime + hr + minutes;
    this.colour = color(rvalue.getValueI(),gvalue.getValueI(),bvalue.getValueI());
  
  }
  
  void drawEvent(){
    textAlign(LEFT);
    textFont(font);
      
    boolean notBooked = this.checkOverlap();
    
    if (notBooked){
      fill(this.colour);
      rect(89, 37.48 + 30.88*(this.startTime-6), 185, this.duration*0.51467);
      fill(0);
      text(this.name, 137, 37.48 + 30.88*(this.startTime-6) + (this.duration*0.51467)/2);
      
    }
   else{
     
     fill(222,255,222);
     rect(width/2-150, height/2-30, 300, 50);
     fill(0);
     //text("Please ensure your events aren't overlapping!", width/2 -130, height/2);
     //println("Please ensure your events aren't overlapping!");
     events.remove(this);
   }
  }
    
  boolean checkOverlap(){
    //boolean intersection = true;
    for (int i = 0; i < events.size(); i++){
      Event other = events.get(i);
      if (this != other){
        if (other.startTime <= this.startTime && this.startTime <= other.endTime) return(false);
        else if (other.startTime <= this.endTime && this.endTime <= other.endTime) return(false);
        else if (this.startTime <= other.startTime && other.endTime <= this.endTime) return(false);
        else if (other.startTime <= this.startTime && this.endTime <= other.endTime) return(false);  
      }
      else return(true);
    }
    return(true);
  }
}
  
  
  
  
  
