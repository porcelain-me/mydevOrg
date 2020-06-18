/******************************************************************************************************************************
 *
 *      @File           :       GPSCampaignCSVIterator.cls
 *      @Version        :       V1.0.0
 *      @Created        :       12th July 2016 by Sudarshan K.
 *      @Purpose        :       JIRA 4836
 *                                  Purpose is GPS Campaigns upload functionality.                   
 *                                  This is Iterator class to Iterate CSV file line by line                    
 *                                  This iterator used in GPSCampaignDLBatch batch class            
 *
 *      @Author         :       Capgemini (Sudarshan K)
 *      @Copyright      :       (c) Capgemini India Pvt. Ltd. 2016
 *
 *      @History        :  
 *
 ********************************************************************************************************************************/
global class GPSCampaignCSVIterator implements Iterator<String>, Iterable<String>{
    
   private String m_CSVData;
   private String m_introValue;
         
   public GPSCampaignCSVIterator(String fileData, String introValue){
      m_CSVData = fileData;
      m_introValue = introValue; 
   }
   
   global Boolean hasNext(){
      return m_CSVData.length() > 1 ? true : false;
   }
   
   global String next(){
    
      String row = m_CSVData.subString(0, m_CSVData.indexOf(m_introValue));
      m_CSVData = m_CSVData.subString(m_CSVData.indexOf(m_introValue) + m_introValue.length(),m_CSVData.length());
      return row;
   }
   
   global Iterator<String> Iterator(){
      return this;   
   }
}