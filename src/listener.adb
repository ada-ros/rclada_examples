with Ada.Command_Line;

with RCL.Logging;
with RCL.Nodes;

with ROSIDL.Dynamic;
with ROSIDL.Typesupport;

-- This example uses the expected methodology from clients

procedure Listener is
   use RCL;

   procedure Callback (Msg  : in out ROSIDL.Dynamic.Message;
                       Info :        ROSIDL.Message_Info) is
      pragma Unreferenced (Info);
   begin
      Logging.Info ("Got chatter! [" & Msg ("data").Get_String & "]");
   end Callback;

begin
   Logging.Set_Name (Ada.Command_Line.Command_Name);
   Logging.Info ("Node starting...");

   declare
      Node : Nodes.Node := Nodes.Init ("listener");
   begin
      Logging.Info ("Node started");

      Node.Subscribe (ROSIDL.Typesupport.Get_Message_Support ("std_msgs", "String"),
                      "/chatter",
                      Callback'Unrestricted_Access);
      --  Normally, with callbacks at library level, this will be a regular 'Access

      loop
         Node.Spin;
      end loop;
   end;
end Listener;
