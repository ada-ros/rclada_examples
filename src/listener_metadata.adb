with Ada.Command_Line;

with RCL.Logging;
with RCL.Nodes;
with RCL.Utils;

with ROSIDL.Dynamic;
with ROSIDL.Typesupport;

-- This example uses the expected methodology from clients

procedure Listener_Metadata is

   package CL renames Ada.Command_Line;

   use RCL;

   Support : constant ROSIDL.Typesupport.Message_Support :=
               ROSIDL.Typesupport.Get_Message_Support
                 ((if CL.Argument_Count >= 1 then CL.Argument (1) else "std_msgs"),
                  (if CL.Argument_Count >= 2 then CL.Argument (2) else "String"));

   procedure Callback (Msg  : in out ROSIDL.Dynamic.Message;
                       Info :        ROSIDL.Message_Info) is
      pragma Unreferenced (Info);
   begin
--        Logging.Info ("Comp:" & Msg ("orientation_covariance").As_Array.Element (1).As_Float64.Element.all'Img);
      Msg.Print_Metadata;
   end Callback;

begin
   Logging.Set_Name (Utils.Command_Name);
   Logging.Info ("Node starting...");

   Logging.Info ("Support identifier is " & Support.Identifier);

   declare
      Node : Nodes.Node := Nodes.Init ("listener");
   begin
      Logging.Info ("Node started");

      Node.Subscribe
        (Support,
         "/chatter",
         Callback'Unrestricted_Access);
      --  Normally, with callbacks at library level, this will be a regular 'Access

      loop
         Node.Spin;
      end loop;
   end;
end Listener_Metadata;
