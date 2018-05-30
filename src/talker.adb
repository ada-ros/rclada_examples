with RCL.Logging;
with RCL.Nodes;
with RCL.Timers;
with RCL.Utils;

with ROSIDL.Dynamic;
with ROSIDL.Typesupport;

-- This example uses the expected methodology from clients

procedure Talker is
   use RCL;

   Node : Nodes.Node := Nodes.Init (Utils.Command_Name);

   procedure Callback (Timer   : in out Timers.Timer;
                       Elapsed :        Duration) is
      pragma Unreferenced (Timer, Elapsed);
   begin
      Logging.Info ("Timer triggered");
   end Callback;

begin
   Logging.Set_Name (Utils.Command_Name);
   Logging.Info ("Node started");

   Node.Timer_Add (1.0, Callback'Unrestricted_Access);
   --  In normal use, with Callback at library level, a regular 'Access will suffice

   loop
      Node.Spin;
   end loop;
end Talker;
