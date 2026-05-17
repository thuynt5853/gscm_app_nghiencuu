<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="PhanCongNgauNhien.aspx.cs" Inherits="WEB.GSTP.PCTP.PhanCongNgauNhien" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddCA_ID" runat="server" Value="0" />
     <asp:HiddenField ID="hddKetquaID" runat="server" Value="0" />
    <asp:HiddenField ID="hddLoaiToa" runat="server" Value="CAPHUYEN" />
    <div class="box">
        <div class="box_nd">
            <div class="boxchung">
                <h4 class="tleboxchung">Phân công Thẩm phán, Thẩm tra viên, Thư ký giải quyết vụ việc</h4>
                <div class="boder" style="padding: 10px;">
                    <table class="table1">
                        <tr>
                            <td style="width: 140px;">Tên tòa án</td>
                            <td colspan="3">
                                <asp:TextBox ID="txtToaan" runat="server" Enabled="false" CssClass="user" Width="420px"></asp:TextBox></td>
                            <td rowspan="9" style="vertical-align: top;">
                                <div class="boxchung">
                                    <h4 class="tleboxchung">Danh sách thẩm phán</h4>
                                    <div class="boder" style="padding: 10px;height:220px;overflow:auto;">
                                        <asp:Repeater ID="rptCanbo" runat="server">
                                            <HeaderTemplate>
                                                <table class="table2">
                                                    <tr class="header">
                                                        <td>TT</td>
                                                        <td>Họ tên</td>
                                                        <td>Chức danh</td>
                                                        <td>Lĩnh vực</td>
                                                    </tr>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <tr>
                                                    <td style="width: 15px;"><%# Container.ItemIndex + 1 %></td>
                                                    <td><%#Eval("Hoten")%> </td>
                                                    <td style="width: 60px;"><%#Eval("TENCHUCDANH")%></td>
                                                    <td style="width: 110px;"><%#Eval("LINHVUC")%></td>
                                                </tr>
                                            </ItemTemplate>
                                            <FooterTemplate></table></FooterTemplate>
                                        </asp:Repeater>
                                    </div>
                                </div>
                            </td>
                        </tr>


                        <tr>
                            <td>Ngày phân công</td>
                            <td style="width: 140px;">
                                <asp:TextBox ID="txtNgayphancong" Enabled="false" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                            </td>
                            <td style="width: 60px;">Chánh án</td>
                            <td style="width: 200px;">
                                <asp:TextBox ID="txtNguoiphancong" Enabled="false" runat="server" CssClass="user" Width="96%"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>Cấp tòa</td>
                            <td colspan="3">
                                <asp:CheckBox ID="chkSoTham" runat="server" Text="Sơ thẩm" Checked="true" AutoPostBack="True" OnCheckedChanged="chkSoTham_CheckedChanged" />
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:CheckBox ID="chkPhucTham" runat="server" Text="Phúc thẩm" Checked="true" AutoPostBack="True" OnCheckedChanged="chkPhucTham_CheckedChanged" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:CheckBox ID="chkGiaiquyetdon" runat="server" Text="TP giải quyết đơn" Checked="true" AutoPostBack="True" OnCheckedChanged="chkGiaiquyetdon_CheckedChanged" /></td>
                            <td colspan="3">Nhận đơn từ ngày &nbsp;<asp:TextBox ID="txtTuNgay" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="txtNgayQuyetDinh_CalendarExtender" runat="server" TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtTuNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                Đến ngày &nbsp;
                                  <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender2" ControlToValidate="txtDenNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:CheckBox ID="chkGiaiquyetvuviec" runat="server" Text="TP giải quyết vụ việc" Checked="false" AutoPostBack="True" OnCheckedChanged="chkGiaiquyetvuviec_CheckedChanged" /></td>
                            <td colspan="3">Thụ lý từ ngày &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:TextBox ID="txtGQVVTu" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtGQVVTu" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtGQVVTu" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                <cc1:MaskedEditValidator ID="MaskedEditValidator3" runat="server" ControlExtender="MaskedEditExtender3" ControlToValidate="txtGQVVTu" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                Đến ngày &nbsp;
                                  <asp:TextBox ID="txtGQVVDen" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtGQVVDen" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtGQVVDen" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                <cc1:MaskedEditValidator ID="MaskedEditValidator4" runat="server" ControlExtender="MaskedEditExtender4" ControlToValidate="txtGQVVDen" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:CheckBox ID="chkThanhvien" runat="server" Text="TP thành viên HĐXX" Checked="false" AutoPostBack="True" OnCheckedChanged="chkThanhvien_CheckedChanged" /></td>
                            <td colspan="3">Thụ lý từ ngày &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:TextBox ID="txtTVXXTu" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtTVXXTu" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtTVXXTu" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                <cc1:MaskedEditValidator ID="MaskedEditValidator5" runat="server" ControlExtender="MaskedEditExtender5" ControlToValidate="txtTVXXTu" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                Đến ngày &nbsp;
                                  <asp:TextBox ID="txtTVXXDen" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtTVXXDen" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtTVXXDen" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                <cc1:MaskedEditValidator ID="MaskedEditValidator6" runat="server" ControlExtender="MaskedEditExtender6" ControlToValidate="txtTVXXDen" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:CheckBox ID="chkThuky" runat="server" Text="Thư ký phiên tòa" Checked="false" AutoPostBack="True" OnCheckedChanged="chkThuky_CheckedChanged" /></td>
                            <td colspan="3">Thụ lý từ ngày &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:TextBox ID="txtThukyTu" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtThukyTu" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender7" runat="server" TargetControlID="txtThukyTu" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                <cc1:MaskedEditValidator ID="MaskedEditValidator7" runat="server" ControlExtender="MaskedEditExtender7" ControlToValidate="txtThukyTu" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                Đến ngày &nbsp;
                                  <asp:TextBox ID="txtThukyDen" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender7" runat="server" TargetControlID="txtThukyDen" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender8" runat="server" TargetControlID="txtThukyDen" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                <cc1:MaskedEditValidator ID="MaskedEditValidator8" runat="server" ControlExtender="MaskedEditExtender8" ControlToValidate="txtThukyDen" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" align="center">&nbsp;</td>
                        </tr>
                        <tr>
                            <td colspan="4" align="center">
                                <asp:Button ID="cmdTraCuu" runat="server" CssClass="buttoninput" Text="Tra cứu" OnClick="cmdTraCuu_Click" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>

        <div class="boxchung">
            <h4 class="tleboxchung">Danh sách vụ án/ vụ việc chưa phân công</h4>
            <div class="boder" style="padding: 10px; min-height: 200px;">
                <div style="width: 97%; padding: 5px; text-align: center; float: left;">
                    <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Phân công ngẫu nhiên" OnClick="cmdUpdate_Click" />
                    <asp:Button ID="cmdPrint" Visible="false" runat="server" OnClientClick="popup_in()" CssClass="buttoninput" Text="In danh sách" />
                </div>
                <div style="float: left; padding: 5px;width:97%;">
                  <asp:Label ID="lblThongbao" runat="server" ForeColor="Red"></asp:Label>
                </div>
                <asp:Repeater ID="rptCapTinh" runat="server">
                    <HeaderTemplate>
                        <table class="table2">
                            <tr class="header">
                                <td rowspan="3">TT</td>
                                <td rowspan="3">Thông tin vụ việc</td>
                                <td rowspan="3">Vụ việc</td>

                                <td rowspan="3">Thẩm phán giải quyết đơn</td>
                                <td colspan="4">Sơ thẩm
                                </td>
                                <td colspan="4">Phúc thẩm
                                </td>
                            </tr>
                            <tr class="header">
                                <td rowspan="2" align="center">Thẩm phán giải quyết vụ việc</td>
                                <td colspan="3" align="center">Hội đồng xét xử</td>
                                <td rowspan="2" align="center">Thẩm phán giải quyết vụ việc</td>
                                <td colspan="3" align="center">Hội đồng xét xử</td>
                            </tr>
                            <tr>
                                <td align="center">Thẩm phán chủ tọa phiên tòa</td>
                                <td align="center">Thẩm phán thành viên</td>
                                <td align="center">Thư ký</td>
                                <td align="center">Thẩm phán chủ tọa phiên tòa</td>
                                <td align="center">Thẩm phán thành viên</td>
                                <td align="center">Thư ký</td>
                            </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td><%# Container.ItemIndex + 1 %></td>
                            <td style="width: 250px;"><%#Eval("TENVUVIEC")%>
                               
                            </td>
                            <td style="width: 110px;"><i>Loại vụ việc</i>: 
                                <br />
                                <%#Eval("TENLOAIVV")%>
                                <br />
                                <i>Giai đoạn</i>: 
                                <br />
                                <%#Eval("TENGIAIDOAN")%>
                            </td>
                            <td style="width: 100px; background-color: #9af69c;"><%#Eval("TPGQD")%></td>
                            <td style="width: 100px; background-color: #ce2e2e;"><%#Eval("TPGQST")%></td>
                            <td style="width: 100px; background-color: #ce2e2e;"><%#Eval("TPCTPT_ST")%></td>
                            <td style="width: 100px; background-color: #ebebe4;"><%#Eval("TPTV_ST")%></td>
                            <td style="width: 100px; background-color: #ce2e2e;"><%#Eval("TKTV_ST")%></td>
                            <td style="width: 100px; background-color: #ebebe4;"><%#Eval("TPGQPT")%></td>
                            <td style="width: 100px; background-color: #ebebe4;"><%#Eval("TPCTPT_PT")%></td>
                            <td style="width: 100px; background-color: #ebebe4;"><%#Eval("TPTV_PT")%></td>
                            <td style="width: 100px; background-color: #ebebe4;"><%#Eval("TKTV_PT")%></td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate></table></FooterTemplate>
                </asp:Repeater>
                <asp:Repeater ID="rptGQD" runat="server" Visible="false">
                    <HeaderTemplate>
                        <table class="table2">
                            <tr class="header">
                                <td >TT</td>
                                 <td >Ngày nhận đơn</td>    
                                <td >Tên vụ việc</td>
                                <td >Loại vụ việc</td>                                
                                <td >Thẩm phán giải quyết đơn</td>    
                            </tr>
                         
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td style="width: 20px;text-align:center;"><%# Container.ItemIndex + 1 %></td>
                             <td style="width: 70px;text-align:center;"><%# Convert.ToDateTime(Eval("NGAYNHANDON")).ToString("dd/MM/yyyy")%> </td>
                            <td ><%#Eval("TENVUVIEC")%>                               
                            </td>
                            <td style="width: 80px;text-align:center;"><%#Eval("TENLOAIVV")%></td>
                           
                            <td style="width: 220px; background-color: #9af69c;text-align:center;"><%#Eval("TENTPGQD")%></td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate></table></FooterTemplate>
                </asp:Repeater>
            </div>


        </div>

    </div>
    <script type="text/javascript">
                                function popup_in() {                                  
                                    var hddCurrID = $("#<%= hddKetquaID.ClientID %>").val();
                                    var link = "/BaoCao/PCTP/ViewReport.aspx?cid=" + hddCurrID;
                                        var width = 1100;
                                        var height = 700;
                                        PopupReport(link, "Phân công thẩm phán giải quyết đơn", width, height);
                                }
                                function PopupReport(pageURL, title, w, h) {
                                   var left = (screen.width / 2) - (w / 2);
                                    var top = (screen.height / 2) - (h / 2);
                                    //OpenPopUpPage(pageURL, null, w, h);
                                    var targetWin = window.open(pageURL, title, 'toolbar=no, channelmode=no,scrollbars=yes,resizable=yes,menubar=no,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
                                   return targetWin;
                               }
                            </script>
</asp:Content>
