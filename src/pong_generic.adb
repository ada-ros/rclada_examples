with Ada.Command_Line; use Ada.Command_Line;

with RCL.Logging;
with RCL.Nodes;
with RCL.Publishers;

with ROSIDL.Dynamic;
with Rosidl.Types;
with ROSIDL.Typesupport;

procedure Pong_Generic is

   --  Example on how to define a self-contained node of which one can have
   --  several instances, using generics.
   --  Since RCL (in C) does not support yet intra-node comms, the demo needs
   --     two processes to work.

   use RCL;

   Support : constant ROSIDL.Typesupport.Message_Support :=
               ROSIDL.Typesupport.Get_Message_Support ("std_msgs", "Int64");

   Topic   : constant String := "/chatter";

   generic
      Name : String;
   package Players is

      Node : Nodes.Node           := Nodes.Init (Name, "/");
      Send : Publishers.Publisher := Node.Publish (Support, Topic);

      -----------
      -- Start --
      -----------

      procedure Start;

      ----------
      -- Recv --
      ----------

      procedure Recv (Node : in out Nodes.Node'Class;
                      Msg  : in out ROSIDL.Dynamic.Message;
                      Info :        ROSIDL.Message_Info);

   end Players;

   package body Players is

      use Rosidl.Types;

      Counter : Int64 := 0;

      ----------
      -- Recv --
      ----------

      procedure Recv (Node : in out Nodes.Node'Class;
                      Msg  : in out ROSIDL.Dynamic.Message;
                      Info :        ROSIDL.Message_Info)
      is
         pragma Unreferenced (Node, Info);

         Got : constant Int64 := Msg ("data").As_Int64;
      begin
         if Got /= Counter then -- from the other side
            Logging.Info (Name & " got:" & Got'Img);
            delay 1.0;
            Counter := Got + 1;
            Msg ("data").As_Int64 := Counter;
            Send.Publish (Msg);
         end if;
      end Recv;

      -----------
      -- Start --
      -----------

      procedure Start is
         Msg : ROSIDL.Dynamic.Message := ROSIDL.Dynamic.Init (Support);
      begin
         Counter := 1;
         Msg ("data").As_Int64 := 1;
         Send.Publish (Msg);
      end Start;

   begin
      Node.Subscribe (Support, Topic, Recv'Unrestricted_Access);
   end Players;

begin
   if Argument_Count = 0 then
      Logging.Warn ("Need one argument, either 'ping' or 'pong'");
      return;
   end if;

   declare
      package Player is new Players (Argument (1));
   begin
      if Argument (1) = "ping" then
         Logging.Info ("Serving...");
         Player.Start;
      end if;

      Player.Node.Spin (During => Forever);
   end;
end Pong_Generic;
