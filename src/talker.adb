with RCL.Logging;
with RCL.Nodes;
with RCL.Publishers;
with RCL.Timers;
with RCL.Utils;

with ROSIDL.Dynamic;
with ROSIDL.Typesupport;

procedure Talker is
   use RCL;

   Support : constant ROSIDL.Typesupport.Message_Support :=
               ROSIDL.Typesupport.Get_Message_Support ("std_msgs", "String");

   Node : Nodes.Node           := Nodes.Init   (Utils.Command_Name);
   Pub  : Publishers.Publisher := Node.Publish (Support, "/chatter");

   Counter : Positive := 1;

   --------------
   -- Callback --
   --------------

   procedure Callback (Node    : in out Nodes.Node'Class;
                       Timer   : in out Timers.Timer;
                       Elapsed :        Duration) is
      pragma Unreferenced (Timer, Elapsed, Node);

      Msg : ROSIDL.Dynamic.Message := ROSIDL.Dynamic.Init (Support);
      Txt : constant String        := "Hello World:" & Counter'Img;
   begin
      Logging.Info ("Publishing: '" & Txt & "'");

      Msg ("data").Set_String (Txt);
      Pub.Publish (Msg);

      Counter := Counter + 1;
   end Callback;

begin
   Logging.Info     ("Node started");

   Node.Timer_Add   (1.0, Callback'Unrestricted_Access);
   --  In normal use, with Callback at library level, a regular 'Access will suffice

   loop
      Node.Spin;
   end loop;
end Talker;
