with Ada.Command_Line; use Ada.Command_Line;

with RCL.Logging;
with RCL.Nodes;
with RCL.Publishers;

with ROSIDL.Dynamic;
with Rosidl.Types;
with ROSIDL.Typesupport;

procedure Pong_Class is
   
   --  Example on how to define a self-contained node of which one can have
   --  several instances, using inheritance.
   --  Since RCL (in C) does not support yet intra-node comms, the demo needs
   --     two processes to work.
   
   use RCL;
   
   Support : constant ROSIDL.Typesupport.Message_Support :=
               ROSIDL.Typesupport.Get_Message_Support ("std_msgs", "Int64");
   
   Topic   : constant String := "/chatter";
   
   package Impl is -- To be able to have bodies right here in the procedure
   
      type Players is new Nodes.Node with private;
      
      ----------
      -- Init --
      ----------

      overriding 
      function Init (Name      : String; 
                     Namespace : String  := "/";
                     Options   : Nodes.Node_Options := Nodes.Default_Options) return Players;
      
      -----------
      -- Start --
      -----------

      procedure Start (This : in out Players);
      
   private
      
      use ROSIDL.Types;
      
      type Players is new Nodes.Node with record
         Counter : Int64 := 0;
         Send    : Publishers.Publisher (Players'Access);
         --  Note that the publisher requires a node and can't outlive it,
         --    as it is a member.
      end record;
      
      ----------
      -- Recv --
      ----------

      procedure Recv (Node : in out Nodes.Node'Class;
                      Msg  : in out ROSIDL.Dynamic.Message;
                      Info :        ROSIDL.Message_Info);
      
   end Impl;
   
   package body Impl is
      
      ----------
      -- Init --
      ----------

      function Init (Name      : String; 
                     Namespace : String  := "/";
                     Options   : Nodes.Node_Options := Nodes.Default_Options) return Players is
      begin 
         return Player : Players := (Nodes.Node'(Nodes.Init (Name, Namespace, Options)) 
                                     with Counter => 0,
                                          Send    => <>) do
            Player.Subscribe (Support, Topic, Recv'Unrestricted_Access);
            Player.Send.Init (Support, Topic);
         end return;
      end Init;
      
      ----------
      -- Recv --
      ----------

      procedure Recv (Node : in out Nodes.Node'Class;
                      Msg  : in out ROSIDL.Dynamic.Message;
                      Info :        ROSIDL.Message_Info) 
      is
         pragma Unreferenced (Info);
         
         Player : Players renames Players (Node);
         --  This downcast is the small price of having the Node'Class
         --    dissociated from the callback function.
         
         Got : constant Int64 := Msg ("data").As_Int64;
      begin
         if Got /= Player.Counter then -- from the other side
            Logging.Info (Player.name & " got:" & Got'Img);
            delay 1.0;
            Player.Counter := Got + 1;
            Msg ("data").As_Int64 := Player.Counter; 
            Player.Send.Publish (Msg);
         end if;
      end Recv;
      
      -----------
      -- Start --
      -----------

      procedure Start (This : in out Players) is
         Msg : ROSIDL.Dynamic.Message := ROSIDL.Dynamic.Init (Support);
      begin
         This.Counter := 1;
         Msg ("data").As_Int64 := 1;
         This.Send.Publish (Msg);
         end Start;
         
   end Impl;
   
   Player : Impl.Players := Impl.Init (Argument (1), "/");
   
begin
   if Argument (1) = "ping" then
      Logging.Info ("Serving...");
      Player.Start;
   end if;
   
   Player.Spin (During => Forever);
end Pong_Class ;
