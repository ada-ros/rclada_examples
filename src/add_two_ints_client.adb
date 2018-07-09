with RCL.Logging;
with RCL.Nodes;
with RCL.Utils;

with ROSIDL.Dynamic;
with ROSIDL.Typesupport;

procedure Add_Two_Ints_Client is
   
   use RCL;

   Node    : Nodes.Node := Nodes.Init (Utils.Command_Name);
   Support : constant ROSIDL.Typesupport.Service_Support :=
               ROSIDL.Typesupport.Get_Service_Support ("example_interfaces", 
                                                       "AddTwoInts");
   
   Request : ROSIDL.Dynamic.Message := ROSIDL.Dynamic.Init (Support.Request_Support);
begin 
   Logging.Info ("Node started for client of AddTwoInts");
   
   Request ("a").As_Int64 := 2;
   Request ("b").As_Int64 := 3;

   Logging.Info ("Requesting sum of 2 + 3");
   declare
      Response : constant ROSIDL.Dynamic.Shared_Message :=                   
                   Node.Client_Call (Support,
                                     "add_two_ints",
                                     Request);
   begin
       Logging.Info ("Got answer:" & Response ("sum").As_Int64.Image);
   end;

end Add_Two_Ints_Client;
