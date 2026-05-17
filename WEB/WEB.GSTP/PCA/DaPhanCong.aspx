<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" 
    CodeBehind="DaPhanCong.aspx.cs" Inherits="WEB.GSTP.PCA.DaPhanCong" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2">
                            <div class="boxchung">
                                <h4 class="tleboxchung">Tìm kiếm</h4>
                                <div class="boder" style="padding: 10px;">
                                    <table class="table1">
                                        <tr>                                
                                             <td style="width:33%">
                                                <div style="float: left; width: 130px; line-height: 20px;">Tên vụ án</div>
                                                <div style="float: left;">
                                                    <asp:TextBox ID="Txtvuan" runat="server" CssClass="user" Width="200px" MaxLength="100"></asp:TextBox>                                                   
                                                </div>
                                              </td>

                                              <td style="width:33%"> 
                                                <div style="float: left; width: 130px; line-height: 20px; margin-left: 30px;">Tên thẩm phán</div>
                                                <div style="float: left;">
                                                    <asp:TextBox ID="Textthamphan" runat="server" CssClass="user" Width="200px" MaxLength="100"></asp:TextBox>                                                    
                                                </div>
                                              </td>
                                            <td style="width:33%">
                                                <div style="float: left; width: 130px; line-height: 20px; margin-left: 30px;">Giai đoạn</div>
                                                <div>
                                                    <asp:DropDownList ID="ddlgiaidoan" runat="server" Width="200px" CssClass="user" AutoPostBack="True" OnSelectedIndexChanged="ddlgiaidoan_SelectedIndexChanged">
                                                        <asp:ListItem Value="1" Text="Giải quyết đơn"></asp:ListItem>
                                                        <asp:ListItem Value="2" Text="Giải quyết án" Selected="True"></asp:ListItem>                                                     
                                                    </asp:DropDownList>
                                                </div>
                                            </td>
                                               
                                        </tr>
                                        <tr>
                                             <td style="width:33%">
                                                <div style="float: left; width: 130px; line-height: 20px;">Từ ngày (phân công)</div>
                                                <div style="float: left;">
                                                    <asp:TextBox ID="txtTuNgay" runat="server" CssClass="user" Width="200px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="txtNgayQuyetDinh_CalendarExtender" runat="server" TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtTuNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                </div>
                                              </td>

                                              <td style="width:33%">
                                                <div style="float: left; width: 130px; line-height: 20px; margin-left: 30px;">Đến ngày (phân công)</div>
                                                <div style="float: left;">
                                                    <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" Width="200px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtDenNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                </div>
                                              </td>
                                            <td align="left" style="width:33%;">
                                                <asp:Button ID="Button1" style="margin-left:30px;" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                                            </td>
                                        </tr>                                        
                                    </table>
                                </div>
                            </div>
                        </td>
                    </tr>

                    <tr>
                        <td colspan="2" align="left">

                            <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="left">
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" 
                                        CssClass="back" Visible="true"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active" Visible="false"
                                        Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                    <asp:Label ID="lbTStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:Label ID="lbTStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                        OnClick="lbTNext_Click"></asp:LinkButton>
                                      <asp:DropDownList ID="dropPageSize" runat="server" Width="55px" CssClass="so"
                                          AutoPostBack="True" OnSelectedIndexChanged="dropPageSize_SelectedIndexChanged">
                                        <asp:ListItem Value="10" Text="10" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="20" Text="20"></asp:ListItem>
                                        <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                        <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                        <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                        <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                        <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div>
                                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="10" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%" OnItemDataBound="dgList_ItemDataBound"> 
                                    <%--OnItemCommand="dgList_ItemCommand"--%> <%--OnItemDataBound="dgList_ItemDataBound">--%>
                                    <Columns>
                                        <asp:BoundColumn DataField="ID_PHAN_CONG_AN" Visible="false"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="15px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                STT
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("RNUM")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>   
                                         <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thụ lý
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("SO_THU_LY")%>
                                                <br />
                                                <%#Eval("NGAY_THU_LY")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Tên vụ án
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("TEN_VU_AN")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>      
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Vai trò
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("VAI_TRO_TP")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>                              
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thẩm phán
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("TEN_THAM_PHAN")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn> 
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Ngày phân công
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("ngay_pc")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>   
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thao tác
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <div align="center">
                                                        <asp:Literal ID="lttSua" runat="server"></asp:Literal>
                                                        &nbsp;&nbsp;
                                                <a style="color:#0e7eee;cursor:pointer;" onclick='popup_in(<%#Eval("ID_PHAN_CONG_AN") %>)'>Sửa</a>
                                                    </div>
                                                 
                                            </ItemTemplate>                                 
                                        </asp:TemplateColumn> 
                                    </Columns>
                                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                </asp:DataGrid>
                            </div>
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false"
                                        CssClass="back" Visible="true"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false"
                                        CssClass="active" Visible="false"
                                        Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                    <asp:Label ID="lbBStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:Label ID="lbBStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                        OnClick="lbTNext_Click"></asp:LinkButton>
                                    <asp:DropDownList ID="dropPageSize2" runat="server" Width="55px" CssClass="so"
                                        AutoPostBack="True" OnSelectedIndexChanged="dropPageSize2_SelectedIndexChanged">
                                        <asp:ListItem Value="10" Text="10" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="20" Text="20"></asp:ListItem>
                                        <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                        <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                        <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                        <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                        <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </td>
                    </tr>

                </table>
            </div>
        </div>
    </div>
      <div style="display: none">
        <asp:Button ID="cmdLoadDsphancong" runat="server"
            Text="Load ds BI don khac" OnClick="cmdLoadDsphancong_Click" />       
    </div>
    <script>
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
        function popup_in(ID) {                                  
            var link = "/PCA/CapNhatThamPhan.aspx?pcaid=" + ID;
            var width = 700;
            var height = 400;
            PopupReport(link, "Cập nhật thẩm phán chủ tọa", width, height);
        }

        function popup_lichsu(ID) {                                  
            var link = "/PCA/LichSuSuaTP.aspx?pcaid=" + ID;
            var width = 1020;
            var height = 400;
            PopupReport(link, "Lịch sử sửa thẩm phán", width, height);
        }

       
        function PopupReport(pageURL, title, w, h) {
            var left = (screen.width / 2) - (w / 2);
            var top = (screen.height / 2) - (h / 2);
                                    //OpenPopUpPage(pageURL, null, w, h);
            var targetWin = window.open(pageURL, title, 'toolbar=no, channelmode=no,scrollbars=yes,resizable=yes,menubar=no,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
            return targetWin;
        }
        function Loadphancong() {
            $("#<%= cmdLoadDsphancong.ClientID %>").click();
        }
    </script>
</asp:Content>