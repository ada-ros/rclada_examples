with RCL.Logging;
with RCL.Nodes;
with RCL.Utils;

procedure Graph_Info is
   use RCL;

   Node : Nodes.Node := Nodes.Init (Utils.Command_Name);
begin
   Logging.Info ("Starting...");
   delay 2.0; -- Let it soak some network info
   
   for Name of Node.Graph_Node_Names loop
      Logging.Info ("Node name: " & Name);
   end loop;
   
   Logging.Info ("---");
   
   declare
      Services : constant Utils.Services_And_Types := Node.Graph_Services;
   begin 
      for I in Services.Iterate loop 
         Logging.Info ("Service: " & Utils.String_Maps.Key (I) & 
                       "; type: "      & Services (I));
      end loop;
   end;
   
   Logging.Info ("---");
   
   declare
      Topics : constant Utils.Topics_And_Types := Node.Graph_Topics;
   begin 
      for I in Topics.Iterate loop 
         Logging.Info ("Topic: " & Utils.String_Maps.Key (I) & 
                         "; type: "      & Topics (I) &
                         "; publishers:" & Node.Graph_Count_Publishers (Utils.String_Maps.Key (I))'Img & 
                         "; subscribers:" & Node.Graph_Count_Subscribers (Utils.String_Maps.Key (I))'Img);
      end loop;
   end;
end Graph_Info;
