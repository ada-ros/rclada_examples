with Ada.Command_Line;

with RCL.Logging;
with RCL.Nodes;
with RCL.Publishers;
with RCL.Timers;
with RCL.Utils;

with ROSIDL.Dynamic;
with ROSIDL.Typesupport;

procedure Talker_Metadata is

   package CL renames Ada.Command_Line;

   use RCL;

   Support : constant ROSIDL.Typesupport.Message_Support :=
               ROSIDL.Typesupport.Get_Message_Support
                 ((if CL.Argument_Count >= 1 then CL.Argument (1) else "std_msgs"),
                  (if CL.Argument_Count >= 2 then CL.Argument (2) else "String"));

   Node : Nodes.Node           := Nodes.Init   (Utils.Command_Name);
   Pub  : Publishers.Publisher := Node.Publish (Support, "/chatter");

   --------------
   -- Callback --
   --------------

   procedure Callback (Timer   : in out Timers.Timer;
                       Elapsed :        Duration) is
      pragma Unreferenced (Timer, Elapsed);

      Msg : ROSIDL.Dynamic.Message := ROSIDL.Dynamic.Init (Support);
   begin
      Logging.Info ("Publishing...");
      Pub.Publish (Msg);
   end Callback;

begin
   Logging.Set_Name (Utils.Command_Name);
   Logging.Info     ("Node started");

   Node.Timer_Add   (1.0, Callback'Unrestricted_Access);
   --  In normal use, with Callback at library level, a regular 'Access will suffice

   loop
      Node.Spin;
   end loop;
end Talker_Metadata;
