global with sharing class WV_EligiblityCSVIterator implements Iterator<String>, Iterable<String>
{
   private String m_CSVData;
   private String m_introValue;
   private Boolean iterationComplete = false;
   public WV_EligiblityCSVIterator(String fileData, String introValue)
   {
      m_CSVData = fileData;
      m_introValue = introValue; 
   }
   
   global Boolean hasNext()
   {
   //  system.debug('********m_CSVData.length():'+m_CSVData.length());
      return m_CSVData.length() > 1 && !iterationComplete   ? true : false ;
   }
   
   global String next()
   {
    
      string firstColumn;
/**
     system.debug('********m_introValue:'+m_introValue);
     system.debug('********m_introValue.len:'+m_introValue.length());
     system.debug('********m_CSVData:'+m_CSVData);
     system.debug('********m_m_CSVData.indexOf:'+m_CSVData.indexOf(m_introValue));
   **/
      String row;
      if(m_CSVData.indexOf(m_introValue) == -1){
          iterationComplete = true;
          row = m_CSVData;
      }
      else { 
          row = m_CSVData.subString(0, m_CSVData.indexOf(m_introValue));
      }
    
 //        system.debug('******** ROW:'+row); 
          if(row.contains('"')){
              row=row.replaceAll('"','').trim();
          }
          
          if(row.contains(',')){
              firstColumn=row.subString(0,row.indexOf(',')).trim();
          }
          else{
              firstColumn=row.trim();
          }
   //       system.debug('******** ROW VALUE(firstColumn):'+firstColumn); 
      //added for adding leading zero if msid starts with zeros.            
      if(firstColumn != null && firstColumn != '' && firstColumn.length()<5 && firstColumn.length()>0){
          if(firstColumn.length()==4){
              firstColumn='0'+firstColumn;
          }
          else if(firstColumn.length()==3){
              firstColumn='00'+firstColumn;
          }
          else if(firstColumn.length()==2){
              firstColumn='000'+firstColumn;
          }
          else{
              firstColumn='0000'+firstColumn;
          }
      }
     // system.debug('******** ROW VALUE(firstColumn11):'+firstColumn);
      m_CSVData = m_CSVData.subString(m_CSVData.indexOf(m_introValue) + m_introValue.length(),m_CSVData.length());
      //system.debug('******** m_CSVData :'+m_CSVData );
      return firstColumn;
   }
   global Iterator<String> Iterator()
   {
      return this;   
   }
}