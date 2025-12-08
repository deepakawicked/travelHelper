class Event{
  String name, st, et;
  float startTime;
  int duration;
  float endTime;
  float hr;
  color colour;
  boolean selected;
  
  Event(String n, String st, int d){
    this.name = n;
    this.st = st;
    this.duration = d;
    int colon = st.indexOf(":");
    String hour = st.substring(0, colon);
    String minute = st.substring(colon+1);
    if (float(minute) == 30) this.startTime = float(hour) + 0.5;
    else this.startTime = float(hour);
    
    
    hr = ((d - (d%60))/60);
    float min = d % 60;
    float minutes = float(minute) + min;
    if (minutes >= 60){
      minutes %= 60;
      hr++;
    }
    minutes /= 60;
    this.endTime = float(hour) + hr + minutes;
    String strEt = str(this.endTime) ;
    int point = strEt.indexOf(".");
    String hrEt = strEt.substring(0,point);
    String minEt = str(int(minutes *= 60));
    if (int(minutes) < 10) minEt = "0" + minEt;
    
    this.et = hrEt + ":" + minEt;
    this.colour = color(rvalue.getValueI(),gvalue.getValueI(),bvalue.getValueI());
    this.selected = false;
  }
  
  void drawEvent(){
    textFont(font);
      
    boolean notBooked = this.checkOverlap();
    
    if (notBooked){
      
      if (selected){
        textAlign(LEFT);
        fill(this.colour);
        rect(280, 37.48 + 30.88*(this.startTime-6), 200, 75);
        fill(0);
        text("Location: " + this.name, 290, 60 + 30.88*(this.startTime-6));
        text("Start time: " + this.st, 290, 80 + 30.88*(this.startTime-6));
        text("End time: " + this.et, 290, 100 + 30.88*(this.startTime-6));
        strokeWeight(3);
        stroke(255,0,0);
        
      }
      
      textAlign(CENTER);
      fill(this.colour);
      rect(89, 37.48 + 30.88*(this.startTime-6), 185, this.duration*0.51467);
      
      fill(0);
      text(this.name, 181.5, 40 + 30.88*(this.startTime-6) + ((this.duration*0.51467)/2));
      
      if (this.endTime > 24) events.remove(this);
      
      stroke(0);
      strokeWeight(1);
      
      
      
      
      
    }
   else{
     
     fill(222,255,222);
     rect(width/2-150, height/2-30, 300, 50);
     fill(0);
     text("Please ensure your events aren't overlapping!", width/2 -130, height/2);
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
  
  
  
  
  
