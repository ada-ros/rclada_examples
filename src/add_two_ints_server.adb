with RCL.Logging;
with RCL.Nodes;
with RCL.Utils;

with ROSIDL.Dynamic;
with ROSIDL.Types; use ROSIDL.Types;
with ROSIDL.Typesupport;

procedure Add_Two_Ints_Server is
   
   use RCL;

   Node : Nodes.Node := Nodes.Init (Utils.Command_Name);
   
   -----------
   -- Adder --
   -----------

   procedure Adder (Node : in out Nodes.Node'Class;
                    Req  : in out ROSIDL.Dynamic.Message;
                    Resp : in out ROSIDL.Dynamic.Message) 
   is
      pragma Unreferenced (Node);
      A : constant Int64 := Req ("a").As_Int64;
      B : constant Int64 := Req ("b").As_Int64;
   begin
      Logging.Info ("Got request, serving" & A'Img & " +" & B'Img);
      Resp ("sum").As_Int64 := A + B;
   end Adder;
   
begin 
   Logging.Info     ("Node started for service AddTwoInts");
   
   Node.Serve (ROSIDL.Typesupport.Get_Service_Support ("example_interfaces", "AddTwoInts"),
               "add_two_ints",
               Adder'Unrestricted_Access);

   Node.Spin (During => Forever);
end Add_Two_Ints_Server;
