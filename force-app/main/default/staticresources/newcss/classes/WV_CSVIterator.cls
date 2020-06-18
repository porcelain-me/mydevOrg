global with sharing class WV_CSVIterator implements Iterator<String>, Iterable<String>
{
   private String m_CSVData;
   private String m_introValue;
   public WV_CSVIterator (String fileData, String introValue)
   {
      m_CSVData = fileData+introValue;
      m_introValue = introValue; 
   }
   global Boolean hasNext()
   {
      return m_CSVData.length() > 1 ? true : false;
   }
   global String next()
   {
      Integer i=m_CSVData.indexOf(m_introValue);
      String row = m_CSVData.subString(0,i);
      Integer j=m_CSVData.length();
      if(j > i){
          m_CSVData = m_CSVData.subString(m_CSVData.indexOf(m_introValue) + m_introValue.length(),j);
      }      
      else{
          m_CSVData ='';
      }
      return row;
   }
   global Iterator<String> Iterator()
   {
      return this;   
   }
}