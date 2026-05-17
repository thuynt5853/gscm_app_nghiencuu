<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SuaCongvan.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.Hoso.Popup.SuaCongvan" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sửa số Công văn</title>
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/Common.js"></script>
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
</head>
<body>
    
    <style type="text/css">
        body {
            width: 98%;
            margin-left: 1%;
            min-width: 0px;
            overflow-y: auto;
            overflow-x: auto;
        }

        .Lable_Popup_Add_VV {
            width: 117px;
        }

        .Input_Popup_Add_VV {
            width: 250px;
        }
    </style>
    <form id="form1" runat="server">
        <asp:HiddenField ID="checkALL" Value="" runat="server" />
    
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>     
         <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
             <div class="box">
                <div class="box_nd">
                    <div class="truong">
                      
                        <table class="table1">                   
                            <tr>
                                <td align="center">
                                    <div class="boxchung">
                                        <h4 class="tleboxchung">Tìm kiếm công văn chuyển</h4>
                                        <div class="boder" style="padding: 10px;">
                                            <table class="table1" style="width:50%; align-content:center"> 
                                                <tr>
                                                    <td>Số CV</td>
                                                    <td>
                                                        <asp:TextBox ID="txtCV_So" runat="server" CssClass="user" Width="152px" MaxLength="250"></asp:TextBox>
                                                    </td>
                                                    <td align="left">Ngày CV</td>
                                                    <td align="left">
                                                        <asp:TextBox ID="txtCV_Ngay" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtCV_Ngay" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtCV_Ngay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                     </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4" align="center">
                                                         <asp:Button ID="btnTimkiem" runat="server" CssClass="btnBuoc  bg_do" Text="Tìm kiếm" OnClick="btnSearch_Click" />
                                                         <asp:Button ID="btnLammoi" runat="server" CssClass="btnBuoc  bg_do" Text="Làm mới" OnClick="btnLammoi_Click" />
                                                        <asp:Button ID="btnDong" runat="server" CssClass="btnBuoc  bg_do" Text="Đóng" OnClientClick="window.close();" />
                                                    </td>
                                                </tr>
                                            </table> 
                                        </div> 
                                    </div>                                
                                </td>
                                </tr>
                            <tr>
                                <td colspan="2"> 
                                <div class="boxchung">
                                  <div style="width:100%;margin-bottom:100px;">
                                      <table class="table1"> 
                                        <tr>
                                            <td>
                                                    <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                                                    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                                                    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
                                            </td>
                                        </tr>
                                         
                                        <tr><td align="center">   
                                                    <div>
                                                        <asp:Label ID="lblAllSoCV" runat="server" CssClass="user" Width="150px" MaxLength="250" Visible="false">Số Công văn</asp:Label>
                                                        <asp:TextBox ID="txtALL_SOCV" runat="server" CssClass="user" Width="152px" MaxLength="250" Visible="false"></asp:TextBox>
                                                        <asp:Label ID="lblAllNgayCV"  runat="server" CssClass="user" Width="150px" MaxLength="250" Visible="false">Ngày Công văn</asp:Label>
                                                        <asp:TextBox ID="txtALL_NGAYCV" runat="server" CssClass="user" Width="100px" MaxLength="10" Visible="false"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtALL_NGAYCV" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtALL_NGAYCV" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                 <div class="phantrang">
                                                    <div class="sobanghi">
                                                        <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                                    </div>
                                                    <div>
                                                        <asp:Button ID="cmdLuu" runat="server" CssClass="btnBuoc  bg_do" Text="Lưu danh sách" OnClick="cmdLuu_Click" Visible="false" />
                                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                        <asp:Button ID="cmdXoaCV" runat="server" CssClass="btnBuoc  bg_do" Text="Xóa Công văn chuyển" OnClick="cmdXoaCV_Click" Visible="false" 
                                                            OnClientClick="return confirm('Bạn thực sự muốn xóa Công văn chuyển khỏi đơn này? ');"  />
                                                    </div>
                                                   
                                                </div>
                                               
                                                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                                    PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                                    ItemStyle-CssClass="chan"  OnItemDataBound="dgList_ItemDataBound">
                                                    <Columns>
                                                        <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>

                                                        <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>
                                                                <asp:CheckBox ID="chkChonAll" AutoPostBack="true" OnCheckedChanged="chkChonAll_CheckChange" ToolTip="Chọn tất cả" runat="server" />
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <asp:CheckBox ID="chkChon" AutoPostBack="true" OnCheckedChanged="chkChon_CheckChange"  runat="server"/>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>TT</HeaderTemplate>
                                                            <ItemTemplate><%# Container.ItemIndex + 1 %></ItemTemplate>
                                                        </asp:TemplateColumn>

                                                         <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Top" HeaderStyle-Width="30%">
                                                            <HeaderTemplate>Thông tin người gửi/đơn vị gửi</HeaderTemplate>
                                                            <ItemTemplate>
                                                                <i>Người gửi:</i><b> <%#Eval("DONGKHIEUNAI") %></b>
                                                                <%# Convert.ToInt32(Eval("LOAIDON"))==2 ? ("(Số "+Eval("CV_SO")+ ")"):"" %>
                                                                <br />
                                                                <i>Địa chỉ</i>:<b> <%#Eval("Diachigui") %></b><br />
                                                                <i><%# Convert.ToInt32(Eval("LOAIDON"))==2 ? "Ngày công văn":"Ngày trên đơn" %>  
                                                                </i>: <%# GetDate(Eval("NGAYGHITRENDON")) %>
                                                                &nbsp;
                                                                <i>Ngày nhận</i>: <%# GetDate(Eval("NGAYNHANDON")) %>
                                                                <br />
                                                                <i>Mã đơn</i>: <%#Eval("MADON") %> &nbsp;Số hiệu: <%#Eval("SOHIEUDON") %>  &nbsp;
                                                              <i>Hình thức</i>: <b><%#Eval("HinhThuc") %></b>
                                                                <%# (Eval("arrCongvan")+"")=="" ? "":"(" + CatXau(Eval("arrCongvan")+"",250) + ")" %>                                                               
                                                            </ItemTemplate>
                                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                            <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Top">
                                                            <HeaderTemplate>Thông tin đơn</HeaderTemplate>
                                                            <ItemTemplate>
                                                                 <i>Số </i><b><%#Eval("BAQD") %></b> <i>Ngày: <b><%# GetDate(Eval("BAQD_NGAYBA")) %></b></i>
                                                                    &nbsp;<b><%#Eval("TOAXX") %></b><br />
                                                                    <i> <%# Convert.ToInt32(Eval("BAQD_CAPXETXU"))==4 ? ((String.IsNullOrEmpty(Eval("BAQD_SO_PT")+"")? "": Eval("Infor_PT")+"<br/>") +
                                                                                        (String.IsNullOrEmpty(Eval("BAQD_SO_ST")+"")? "": Eval("Infor_ST") + "<br/>")):"" %></i>
                                                                    <i> <%# Convert.ToInt32(Eval("BAQD_CAPXETXU"))==3 ? (String.IsNullOrEmpty(Eval("BAQD_SO_ST")+"")? "": Eval("Infor_ST") + "<br/>"):""%></i>
                                                                    <i><b style="color: #0e7eee;"><%#Eval("TRANGTHAICHUYEN") %>:</b></i>  <b><%#Eval("NOICHUYEN") %></b> <i>(Số <%#Eval("CD_SOCV") %> - <%# GetDate(Eval("CD_NGAYCV")) %>)</i>

                                                                <br />

                                                                <i>Ghi chú: </i><%#Eval("GHICHU") %>
                                                                <asp:LinkButton ID="cmdXemthem" runat="server" ForeColor="#0e7eee" Visible="false" Text="[Xem thêm]"></asp:LinkButton>
                                                                <br />
                                                                <div style='color:#0e7eee; font-weight:bold; display:<%#Eval("IsShowNB")%>'>

                                                                    <%# String.IsNullOrEmpty(Eval("KQGQNoiBo")+"")?"":"KQ GQ:"+Eval("KQGQNoiBo") %>
                                                                </div>
                                                                
                                                            </ItemTemplate>
                                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                            <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                                        </asp:TemplateColumn>
                                                      
                                                        <asp:TemplateColumn HeaderStyle-Width="110px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>Thông tin giải quyết</HeaderTemplate>
                                                            <ItemTemplate>
                                                                <div style='width: 100%; display: <%#Eval("IsShowNB") %>'>
                                                                    <div style='width: 100%; display: <%#Eval("IsShowDDK") %>'>
                                                                        <div style='width: 100%; display: <%#Eval("IsShowTLMOI") %>'>
                                                                            <b>Thụ lý mới</b><br />
                                                                            <i>Số: </i><%#Eval("TL_SO") %> - <%# GetDate(Eval("TL_NGAY")) %>
                                                                            <br />
                                                                            <i>Thẩm phán</i><br />
                                                                            <b><%#Eval("TENTHAMPHAN") %></b> (<%#Eval("CD_SOTOTRINH") %>/TTr-TANDTC-VP)
                                                                        </div>
                                                                        <div style='width: 100%; display: <%#Eval("IsShowDATL") %>'>
                                                                            <b>Đã thụ lý</b>
                                                                            <br />
                                                                            <%#Eval("arrTTTL") %>
                                                                        </div>
                                                                    </div>
                                                                    <div style='width: 100%; display: <%#Eval("IsShowCDDK") %>'>
                                                                        <b>Đơn chưa đủ điều kiện</b>
                                                                        <br />
                                                                        <br />
                                                                        <asp:LinkButton ID="cmdBSTaiLieu" runat="server" Font-Bold="true" ForeColor="#0e7eee" CommandArgument='<%#Eval("ID") %>' CommandName="BOSUNGTL" Text="Bổ sung tài liệu"></asp:LinkButton>

                                                                    </div>
                                                                </div>
                                                                <div style='width: 100%; display: <%#Eval("IsShowTK") %>'>
                                                                    <b>Chuyển đơn</b>
                                                                </div>
                                                                 <div style='width: 100%; display: <%#Eval("IsGXN") %>'>
                                                                            <i>GXN Số: </i><%#Eval("GXNSO") %> - <%# GetDate(Eval("GXNNGAY")) %>
                                                                </div>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderStyle-Width="35px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>Số Công văn</HeaderTemplate>
                                                            <ItemTemplate>
                                                                <asp:TextBox ID="txtCD_SOCV" runat="server" Text='<%# Eval("CD_SOCV")%>' CssClass="user" Width="35px" MaxLength="50" Enabled="false"></asp:TextBox>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderStyle-Width="80px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>Ngày Công văn</HeaderTemplate>
                                                            <ItemTemplate>
                                                                  <asp:TextBox ID="txtCD_NGAYCV" runat="server" Text='<%# Eval("CD_NGAYCV")%>' CssClass="user" Width="75px" MaxLength="10" Enabled="false"></asp:TextBox>
                                                                <cc1:CalendarExtender ID="txtCD_NGAYCV_CalendarExtender" runat="server" TargetControlID="txtCD_NGAYCV" Format="dd/MM/yyyy" />
                                                                <cc1:MaskedEditExtender ID="txtCD_NGAYCV_MaskedEditExtender3" runat="server" TargetControlID="txtCD_NGAYCV" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" Century="2000" CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="₫" CultureDateFormat="DMY" CultureDatePlaceholder="/" CultureDecimalPlaceholder="," CultureThousandsPlaceholder="." CultureTimePlaceholder=":" />
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                    </Columns>
                                                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                </asp:DataGrid>
                                                <div class="phantrang">
                                                    <div class="sobanghi">
                                                        <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                                    </div>
                                                  
                                                </div>
                                
                                            </td>
                                        </tr>
                                        
                                      </table>
                                  </div>
                                </div>      
                                </td>
                            </tr>
                        </table>
                      
                    </div>
                </div>
             </div>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
      </form>
                                        <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
                                            <ProgressTemplate>
                                                <div class="processmodal">
                                                    <div class="processcenter">
                                                        <img src="/UI/img/process.gif" />
                                                    </div>
                                                </div>
                                            </ProgressTemplate>
                                        </asp:UpdateProgress>
    
    
</body>
<script src="/UI/js/chosen.jquery.js"></script>
<script src="/UI/js/init.js"></script>
<script src="/UI/js/jquery.enhsplitter.js"></script>
     <script type="text/javascript">
        function pageLoad(sender, args) {           
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }

        }
    </script>
</html>
