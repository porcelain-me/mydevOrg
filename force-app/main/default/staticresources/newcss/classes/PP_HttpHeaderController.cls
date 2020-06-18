public class PP_HttpHeaderController {
  public String AttributeKey {get; set;}
  public String AttributeVal {get; set;}
  public void getSideEffects() {
    ApexPages.currentPage().getHeaders().put(this.AttributeKey, this.AttributeVal);
  }
}