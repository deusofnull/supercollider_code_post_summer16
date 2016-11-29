
(
w = Window.new("GUI", Rect(200,200, 255, 100));

b = Button.new(w, Rect(10,0,80, 30));
s = Slider.new(w, Rect(95,0,150,30));
c = CompositeView.new(w, Rect(20, 35, 100,60));

StaticText.new(c,Rect(0,0,80,30)).string_("hey");
StaticText.new(c, Rect(20,30,80,30)).string_("everyone");

b.action = { c.visible = b.value.asBoolean.not };
s.action = {c.bounds = Rect(s.value * 150 + 20, 35, 100,100) };
w.front;
)

s.quit;