<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="pSuaCongvan.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.Popup.pSuaCongvan" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>
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
        
        .chosen-container-single .chosen-single input[type="text"] {
            position: fixed;
        }
    </style>
 
            <asp:HiddenField ID="checkALL" Value="" runat="server" />
             <div class="box">
                <div class="box_nd">
                    <div class="truong">
                      
                        <table class="table1">   
                            <tr>
                                <td colspan="2"> 
                                <div class="boxchung">
                                  <div style="width:100%;margin-bottom:100px;">
                                      <table class="table1"> 
                                        <tr>
                                            <td>
                                                    <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                                                    <asp:HiddenField ID="hddSOPHATHANH_ID" Value="0" runat="server" />
                                                    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                                                    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
                                            </td>
                                        </tr>
                                         
                                        <tr><td align="center">   
                                                    <div>
                                                        <asp:Label ID="lblAllSoCV" runat="server" CssClass="user" Width="100px" MaxLength="250" Visible="false">Số Văn Bản</asp:Label>
                                                        <asp:TextBox ID="txtALL_SOCV" runat="server" CssClass="user" Width="152px" MaxLength="250" Visible="false"></asp:TextBox>
                                                        <asp:Label ID="lblAllNgayCV"  runat="server" CssClass="user" Width="100px" MaxLength="250">Ngày Văn Bản</asp:Label>
                                                        <asp:TextBox ID="txtALL_NGAYCV" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtALL_NGAYCV" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtALL_NGAYCV" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                        
                                                        <asp:Label ID="lblAllNguoiky" runat="server" CssClass="user" Width="80px" MaxLength="250">Người ký</asp:Label>
                                                        <asp:DropDownList ID="ddlNguoiKy" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>

                                                        <asp:TextBox ID="txtALL_NGUOIKY" runat="server" CssClass="user" Width="152px" MaxLength="250"  Visible ="false"></asp:TextBox>
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
                                                        <asp:Button ID="cmdLuu" runat="server" CssClass="btnBuoc  bg_do" Text="Lưu" OnClick="cmdLuu_Click"  OnClientClick="return validate();" />
                                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                        <asp:Button ID="cmdXoaCV" runat="server" CssClass="btnBuoc  bg_do" Text="Xóa" OnClick="cmdXoaCV_Click" 
                                                            OnClientClick="return confirm('Bạn thực sự muốn xóa Số Văn bản khỏi vụ án này? ');"  />
                                                        &nbsp;&nbsp;&nbsp;&nbsp;
                                                        <asp:Button ID="cmdQuaylai" runat="server" CssClass="btnBuoc  bg_do" Text="Quay lại" OnClick="cmdQuaylai_Click" />
                                                    </div>
                                                   
                                                </div>
                                               
                                                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                                    PageSize="30" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                                    ItemStyle-CssClass="chan">
                                                    <Columns>
                                                        <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>

                                                        <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                           
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
                                                                
                                                                <i><%# Convert.ToInt32(Eval("LOAIDON"))==2 ? "Ngày công văn":"Ngày trên đơn" %>  
                                                                </i>: <%# GetDate(Eval("NGAYGHITRENDON")) %>
                                                                &nbsp;
                                                                <i>Ngày nhận</i>: <%# GetDate(Eval("NGAYNHANDON")) %>
                                                                <br />
                                                                <i>Mã đơn</i>: <%#Eval("MADON") %> &nbsp;Số hiệu: <%#Eval("SOHIEUDON") %>  &nbsp;
                                                              
                                                                <%# (Eval("arrCongvan")+"")=="" ? "":"(" + CatXau(Eval("arrCongvan")+"",250) + ")" %>
                                                              
                                                            </ItemTemplate>
                                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                            <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Top">
                                                            <HeaderTemplate>Thông tin đơn</HeaderTemplate>
                                                            <ItemTemplate>
                                                                 <i>Số </i><%#Eval("BAQD") %> <i>Ngày: <%# GetDate(Eval("BAQD_NGAYBA")) %></i>
                                                                    &nbsp;<%#Eval("TOAXX") %><br />
                                                                    <i> <%# Convert.ToInt32(Eval("BAQD_CAPXETXU"))==4 ? ((String.IsNullOrEmpty(Eval("BAQD_SO_PT")+"")? "": Eval("Infor_PT")+"<br/>") +
                                                                                        (String.IsNullOrEmpty(Eval("BAQD_SO_ST")+"")? "": Eval("Infor_ST") + "<br/>")):"" %></i>
                                                                    <i> <%# Convert.ToInt32(Eval("BAQD_CAPXETXU"))==3 ? (String.IsNullOrEmpty(Eval("BAQD_SO_ST")+"")? "": Eval("Infor_ST") + "<br/>"):""%></i>
                                                                    <i><b style="color: #0e7eee;"><%#Eval("TRANGTHAICHUYEN") %>:</b></i> <%#Eval("NOICHUYEN") %>

                                                                <br />

                                                                <i>Ghi chú: </i><%#Eval("GHICHU") %>
                                                                <asp:LinkButton ID="cmdXemthem" runat="server" ForeColor="#0e7eee" Visible="false" Text="[Xem thêm]"></asp:LinkButton>
                                                                <br />
                                                                <div style='color:#0e7eee; font-weight:bold; display:<%#Eval("IsShowNB")%>'>

                                                                    <%# String.IsNullOrEmpty(Eval("KQGQNoiBo")+"")?"":"KQ GQ:"+Eval("KQGQNoiBo") %>
                                                                </div>
                                                               

                                                                <%-- &nbsp;&nbsp;<asp:LinkButton ID="cmdKinhtrinh"   Visible='<%# GetBool(Eval("CHIDAO_COKHONG")) %>' runat="server" Font-Bold="true" ForeColor="#0e7eee" CommandArgument='<%#Eval("ID") %>' CommandName="KINHTRINH" Text="Báo cáo lãnh đạo"></asp:LinkButton>--%>
                                                            </ItemTemplate>
                                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                            <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                                        </asp:TemplateColumn>
                                                       <%-- <asp:TemplateColumn HeaderStyle-Width="15px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>Số đơn</HeaderTemplate>
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="cmdSoDonTrung" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%#Eval("arrDonID") %>' CommandName="SoDonTrung" Text=''></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>--%>
                                                        <asp:TemplateColumn HeaderStyle-Width="110px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>Thông tin giải quyết</HeaderTemplate>
                                                            <ItemTemplate>
                                                                <div style='width: 100%; display: <%#Eval("IsShowNB") %>'>
                                                                    <div style='width: 100%; display: <%#Eval("IsShowDDK") %>'>
                                                                        <div style='width: 100%; display: <%#Eval("IsShowTLMOI") %>'>
                                                                            Thụ lý mới<br />
                                                                            <i>Số: </i><%#Eval("TL_SO") %> - <%# GetDate(Eval("TL_NGAY")) %>
                                                                            <br />
                                                                            <i>Thẩm phán</i><br />
                                                                            <b><%#Eval("TENTHAMPHAN") %></b> (<%#Eval("CD_SOTOTRINH") %>/TTr-TANDTC-VP)
                                                                        </div>
                                                                        <div style='width: 100%; display: <%#Eval("IsShowDATL") %>'>
                                                                            Đã thụ lý
                                                                            <br />
                                                                            <%#Eval("arrTTTL") %>
                                                                        </div>
                                                                    </div>
                                                                    <div style='width: 100%; display: <%#Eval("IsShowCDDK") %>'>
                                                                        <b>Đơn chưa đủ điều kiện</b>
                                                                       
                                                                       
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
                                                        <asp:TemplateColumn HeaderStyle-Width="50px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>Số Văn bản</HeaderTemplate>
                                                            <ItemTemplate>
                                                                <asp:TextBox ID="txtCD_SOCV" runat="server" Text='<%# Eval("SOVB")%>' CssClass="user" Width="50px" MaxLength="50" Enabled="false"></asp:TextBox>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderStyle-Width="80px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>Ngày Văn bản</HeaderTemplate>
                                                            <ItemTemplate>
                                                                  <asp:TextBox ID="txtCD_NGAYCV" runat="server" Text='<%# Eval("NGAYVB")%>' CssClass="user" Width="75px" MaxLength="10" Enabled="false"></asp:TextBox>
                                                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtCD_NGAYCV" Format="dd/MM/yyyy" />
                                                                <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtCD_NGAYCV" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" Century="2000" CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="₫" CultureDateFormat="DMY" CultureDatePlaceholder="/" CultureDecimalPlaceholder="," CultureThousandsPlaceholder="." CultureTimePlaceholder=":" />
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderStyle-Width="100px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>Người ký Văn bản</HeaderTemplate>
                                                            <ItemTemplate>
                                                                <asp:TextBox ID="txtCD_NGUOIKY" runat="server" Text='<%# Eval("NGUOIKY")%>' CssClass="user" Width="100px" MaxLength="200" Enabled="false"></asp:TextBox>
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
                                     
     <script type="text/javascript">
        function pageLoad(sender, args) {           
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }

         }

         function validate() {
             var txtALL_NGAYCV = document.getElementById('<%=txtALL_NGAYCV.ClientID%>');
             if (txtALL_NGAYCV != null && txtALL_NGAYCV.value == '') {
                 alert('Chưa nhập ngày văn bản. Hãy nhập lại!');
                 txtALL_NGAYCV.focus();
                 return false;
             }
             var txtALL_NGUOIKY = document.getElementById('<%=txtALL_NGUOIKY.ClientID%>');
             var LengthNGUOIKY = txtALL_NGUOIKY.value.trim().length;
             if (LengthNGUOIKY == 0) {
                 alert('Bạn chưa nhập người ký. Hãy nhập lại!');
                 txtALL_NGUOIKY.focus();
                 return false;
             }
             return true;
         }
    </script>
</asp:Content>