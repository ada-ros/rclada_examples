with RCL.Logging;
with RCL.Nodes;
with RCL.Utils;

procedure Graph_Info is
   use RCL;

   Node : constant Nodes.Node := Nodes.Init (Utils.Command_Name);
begin
   Logging.Info ("Starting...");
   delay 2.0; -- Let it soak some network info
   
   for Name of Node.Graph_Node_Names loop
      Logging.Info ("Node name: " & Name);
   end loop;
   
   Logging.Info ("---");
   
   for Service of Node.Graph_Services loop 
      Logging.Info ("Service: " & Service.Name & 
                      "; type: "  & Service.Ttype);
   end loop;
   
   Logging.Info ("---");
   
   for Topic of Node.Graph_Topics loop
      Logging.Info ("Topic: " & Topic.Name & 
                      "; type: "      & Topic.Ttype &
                      "; publishers:" &  Node.Graph_Count_Publishers  (Topic.Name)'Img & 
                      "; subscribers:" & Node.Graph_Count_Subscribers (Topic.Name)'Img);
   end loop;
   
end Graph_Info;
