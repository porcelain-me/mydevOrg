public class PageMessages {
    
    public String CustomPageMessages_ClosableErrorsRenderPlaceHolder {
        get { 
            if(CustomPageMessages_ClosableErrorsRenderPlaceHolder == null) CustomPageMessages_ClosableErrorsRenderPlaceHolder = ''; 
            return CustomPageMessages_ClosableErrorsRenderPlaceHolder; 
        }
        private set;
    } 

    public List<PageMessagesHandler.PageMessage> getPageMessages() {
        return PageMessagesHandler.getMessages();
    }

}