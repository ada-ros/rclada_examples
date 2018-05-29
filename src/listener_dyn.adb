with RCL.Logging;
with RCL.Nodes;
with RCL.Subscriptions;

with ROSIDL.Dynamic;

-- This example uses low level subscription and dynamic messages

procedure Listener_Dyn is
   use RCL;

   Msg : ROSIDL.Dynamic.Message :=
           ROSIDL.Dynamic.Init ("std_msgs", "String");
begin
   Logging.Set_Name ("listener_dyn");
   Logging.Info ("Node starting...");

   declare
      Node : Nodes.Node := Nodes.Init ("listener");
   begin
      Logging.Info ("Node started");

--      Logging.Info ("SUPPORT: " & System.Address_Image (Rosidl.Std_Msgs.Msg.Typesupport_String.all'Address));
      declare
         Sub  : Subscriptions.Subscription :=
                  Subscriptions.Init (Node,
                                      Msg.Typesupport,
                                      "chatter");

         Info : ROSIDL.Message_Info;
      begin
         Logging.Info ("Subscription started");

         while True loop
            delay 1.0;
            if Sub.Take_Raw (Msg.To_Ptr, Info) then
               Logging.Info ("Got chatter! [" & Msg ("data").Get_String & "]");
            else
               Logging.Info (":'(");
            end if;
         end loop;
      end;
   end;

   Logging.Info ("Node shut down");
end Listener_Dyn;
