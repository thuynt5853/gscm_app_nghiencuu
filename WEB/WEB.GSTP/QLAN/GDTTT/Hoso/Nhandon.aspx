<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Nhandon.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.Hoso.Nhandon" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <style type="text/css">
        .DonGDTCol1 {
            width: 100px;
        }

        .DonGDTCol2 {
            width: 240px;
        }

        .DonGDTCol3 {
            width: 85px;
        }

        .DonGDTCol4 {
            width: 160px;
        }

        .DonGDTCol5 {
            width: 70px;
        }
    </style>
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
                                            <td class="DonGDTCol1">Tòa án chuyển</td>
                                            <td class="DonGDTCol2">
                                                <asp:DropDownList ID="ddlToachuyen" CssClass="chosen-select" runat="server" Width="230px"> </asp:DropDownList>
                                              
                                            </td>
                                            <td class="DonGDTCol3">Loại án</td>
                                            <td class="DonGDTCol4">
                                                <asp:DropDownList ID="ddlLoaiAn" CssClass="chosen-select" runat="server" Width="160px"> </asp:DropDownList>
                                            </td>
                                            <td class="DonGDTCol5"></td>
                                            <td>
                                                
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Hình thức đơn</td>
                                            <td>
                                                <asp:DropDownList ID="ddlHinhthucdon" Width="230px" CssClass="chosen-select" runat="server">
                                                    <asp:ListItem Value="0" Text="--- Tất cả ---" Selected="True"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Đơn"></asp:ListItem>
                                                    <asp:ListItem Value="2" Text="Đơn tố cáo"></asp:ListItem>
                                                    <asp:ListItem Value="3" Text="Đơn + Công văn"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td>Người/CQ gửi</td>
                                            <td>
                                                <asp:TextBox ID="txtNguoigui" runat="server" CssClass="user" Width="152px" MaxLength="250"></asp:TextBox>
                                            </td>
                                            <td>Số CMND</td>
                                            <td >
                                                <asp:TextBox ID="txtSoCMND" runat="server" CssClass="user" Width="100px" MaxLength="250"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                        <td>Ngày chuyển từ</td>
                                            <td>
                                                <asp:TextBox ID="txtNgaychuyenTu" runat="server" CssClass="user" Width="222px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgaychuyenTu" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgaychuyenTu" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                            <td>Đến ngày</td>
                                            <td >
                                                <asp:TextBox ID="txtNgaychuyenDen" runat="server" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtNgaychuyenDen" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgaychuyenDen" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                              <td>Mã đơn</td>
                                            <td >
                                                <asp:TextBox ID="txtSohieudon" runat="server" CssClass="user" Width="100px" MaxLength="50"></asp:TextBox>
                                            </td>
                                        </tr>                                      
                                        <tr>                                            
                                            <td>Số công văn</td>
                                            <td>
                                                <asp:TextBox ID="txtCV_So" runat="server" CssClass="user" Width="222px" MaxLength="250"></asp:TextBox>
                                            </td>
                                            <td>Trạng thái</td>
                                            <td colspan="3">
                                                <asp:RadioButtonList ID="rbtTrangthai" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rbtTrangthai_SelectedIndexChanged">
                                                    <asp:ListItem Value="1" Text="Chưa nhận" Selected="True"></asp:ListItem>
                                                    <asp:ListItem Value="2" Text="Đã nhận"></asp:ListItem>
                                                    <asp:ListItem Value="3" Text="Trả lại"></asp:ListItem>
                                                </asp:RadioButtonList>
                                            </td>
                                            
                                        </tr>
                                       
                                      
                                         <tr>
                        <td colspan="4">
                            <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>
                                        <tr>
                                            <td></td>
                                            <td colspan="3" align="Center" >
                                                  <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                                                 
                                            </td>
                                        </tr>
                                         
                                    </table>
                                </div>
                            </div>
                             <div class="boxchung">                                
                                <div class="boder" style="padding: 10px;">
                                       <table class="table1">
                                        <tr>
                                            <td style="width:100px;"><asp:Label ID="lblGhichu" runat="server" Text="Ghi chú"></asp:Label></td>
                                           <td >
                                                <asp:TextBox ID="txtGhichu" runat="server" CssClass="user" Width="99.5%" MaxLength="500"></asp:TextBox>
                                            </td>
                                            <td style="width:200px;">
                                                <asp:Button ID="cmdNhandon" runat="server" CssClass="buttoninput" Text="Nhận đơn" OnClick="cmdNhandon_Click"/>
                                                <asp:Button ID="cmdTralai" runat="server" CssClass="buttoninput" Text="Trả lại" OnClick="cmdTralai_Click" />
                                            </td>
                                        </tr>

                                       </table>
                                        </div>
                            </div>
                        </td>
                    </tr>                 
                  
                    <tr>
                        <td colspan="2">
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
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
                                    <asp:DropDownList ID="ddlPageCount" runat="server" Width="55px" CssClass="so" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount_SelectedIndexChanged">
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
                            <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="10" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan" >
                                <Columns>
                                    <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="25px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate><asp:CheckBox ID="chkChonAll" AutoPostBack="true" OnCheckedChanged="chkChonAll_CheckChange"  ToolTip="Chọn tất cả" runat="server" /></HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkChon" AutoPostBack="true"  ToolTip='<%#Eval("ID")%>'    OnCheckedChanged="chkChon_CheckedChanged" runat="server" />
                                        </ItemTemplate>
                                    </asp:TemplateColumn> 
                                    <asp:TemplateColumn HeaderStyle-Width="25px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>STT</HeaderTemplate>
                                        <ItemTemplate><%# Container.ItemIndex + 1 %></ItemTemplate>
                                    </asp:TemplateColumn>             
                                       <asp:TemplateColumn  HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Top">
                                        <HeaderTemplate>Thông tin đơn</HeaderTemplate>
                                        <ItemTemplate>
                                            <i>Người gửi:</i><b> <%#Eval("NGUOIGUI_HOTEN") %></b><br />  
                                          <i>Địa chỉ</i>:<b> <%#Eval("Diachigui") %></b><br />                                                                                                                              
                                             <i>Ngày ghi trên đơn</i>: <%# (Eval("NGAYGHITRENDON")+"")==""?"":Convert.ToDateTime(Eval("NGAYGHITRENDON")).ToString("dd/MM/yyyy") %>
                                            &nbsp;
                                              <i>Ngày nhận đơn</i>: <%# Convert.ToDateTime(Eval("NGAYNHANDON")).ToString("dd/MM/yyyy") %>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                    </asp:TemplateColumn>
                                     <asp:TemplateColumn  HeaderStyle-HorizontalAlign="Center"  ItemStyle-VerticalAlign="Top">
                                        <HeaderTemplate>Thông tin chuyển đơn</HeaderTemplate>
                                        <ItemTemplate>
                                          <i>Ngày chuyển</i>:<b> <%# Convert.ToDateTime(Eval("NGAYCHUYEN")).ToString("dd/MM/yyyy") %>  </b>
                                            &nbsp;
                                            <i>Số công văn</i>: <%#Eval("SOCV") %>   
                                            <br />
                                            <i>Tòa án chuyển</i>:<b> <%#Eval("TENTOACHUYEN") %>     </b>
                                            <br />
                                            <i>Trạng thái</i>: <b> <%#Eval("TENTRANGTHAI") %>     </b>
                                             &nbsp;
                                            <i>Ngày nhận</i>: <%# Getdate(Eval("NGAYNHAN")) %>  </b>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                    </asp:TemplateColumn>
                                </Columns>
                                <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            </asp:DataGrid>
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active" Visible="true"
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
                                    <asp:DropDownList ID="ddlPageCount2" runat="server" Width="55px" CssClass="so" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount2_SelectedIndexChanged">
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
    <script type="text/javascript">
        function PopupReport(pageURL, title, w, h) {
            var left = (screen.width / 2) - (w / 2);
            var top = (screen.height / 2) - (h / 2);
            var targetWin = window.open(pageURL, title, 'toolbar=no, channelmode=no,location =no,scrollbars=yes,resizable=no,menubar=no,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
            return targetWin;
        }
</script>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
</asp:Content>

