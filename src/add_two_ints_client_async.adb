with RCL.Logging;
with RCL.Nodes;
with RCL.Utils;

with ROSIDL.Dynamic;
with ROSIDL.Typesupport;

procedure Add_Two_Ints_Client_Async is
   
   use RCL;

   Done    : Boolean    := False with Volatile;
   Node    : Nodes.Node := Nodes.Init (Utils.Command_Name);
   Support : constant ROSIDL.Typesupport.Service_Support :=
               ROSIDL.Typesupport.Get_Service_Support ("example_interfaces", 
                                                       "AddTwoInts");
   
   Request : ROSIDL.Dynamic.Message := ROSIDL.Dynamic.Init (Support.Request_Support);
   
   procedure Client (Node     : in out Nodes.Node'Class;
                     Response : ROSIDL.Dynamic.Message) is
      pragma Unreferenced (Node);
   begin
      Done := True;
      Logging.Info ("Got answer:" & Response ("sum").As_Int64.Image);
   end Client;
   
begin 
   Logging.Info     ("Node started for async client of AddTwoInts");
   
   Request ("a").As_Int64 := 2;
   Request ("b").As_Int64 := 3;

   Logging.Info ("Requesting sum of 2 + 3");
   Node.Client_Call (Support,
                     "add_two_ints",
                     Request,
                     Client'Unrestricted_Access);
   
   while not Done loop
      Node.Spin;
   end loop;
end Add_Two_Ints_Client_Async;
