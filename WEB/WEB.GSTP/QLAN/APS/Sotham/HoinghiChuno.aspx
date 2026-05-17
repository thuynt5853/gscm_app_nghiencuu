<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="HoinghiChuno.aspx.cs" Inherits="WEB.GSTP.QLAN.APS.Sotham.HoinghiChuno" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
      <asp:HiddenField ID="hddid" runat="server" Value="0" />
        <div class="box">
        <div class="box_nd">
            <div class="boxchung">
                <h4 class="tleboxchung">Quyết định công nhận phương án phục hồi hoạt động kinh doanh</h4>
                <div class="boder" style="padding: 10px;">
                    <table class="table1">                        
                        <tr>
                            <td style="width:165px">Số quyết định<span class="batbuoc">(*)</span></td>
                              <td style="width:150px">
                                <asp:TextBox ID="txtSoQD" runat="server" CssClass="user" Width="90%" MaxLength="50"></asp:TextBox>
                            </td>
                             <td style="width:120px">Ngày quyết định<span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:TextBox ID="txtNgayQD" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgayQD" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                            </td>
                        </tr>
                        </table>
                    </div>
                </div>
             <div class="boxchung">
                <h4 class="tleboxchung">Thông tin phương án phục hồi hoạt động kinh doanh</h4>
                <div class="boder" style="padding: 10px;">
                     <table class="table1">                        
                        <tr>
                            <td style="width:165px">Nghị quyết hội nghị chủ nợ số</td>
                              <td style="width:150px">
                                <asp:TextBox ID="txtNQHNCNSo" runat="server" CssClass="user" Width="90%" MaxLength="250"></asp:TextBox>
                            </td>
                             <td style="width:120px">Ngày ra nghị quyết</td>
                            <td>
                                <asp:TextBox ID="txtNgayNQ" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayNQ" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayNQ" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                            </td>
                        </tr>
                         <tr>
                            <td >Thời gian thực hiện phương án phục hồi HĐKD từ ngày<span class="batbuoc">(*)</span> </td>
                              <td >
                                  <asp:TextBox ID="txtPA_Tungay" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtPA_Tungay" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtPA_Tungay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                            </td>
                             <td>Đến ngày<span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:TextBox ID="txtPA_Denngay" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtPA_Denngay" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtPA_Denngay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                            </td>
                        </tr>
                        </table>
                    </div>
                </div>
           
                <table class="table1">
                    <tr>
                        <td style="text-align: center;">
                        <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                            </td>
                    </tr>
                    <tr>
                        <td style="text-align: center;">
                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu quyết định công nhận" OnClick="btnUpdate_Click"  />
                         
                        </td>
                    </tr>
                    </table>
              
                         <div class="boxchung" style="margin-top:30px;">
                <h4 class="tleboxchung">Kết quả của phương án phục hồi hoạt động kinh doanh đã có quyết định công nhận của Tòa án</h4>
                <div class="boder" style="padding: 10px;">
                     <table class="table1">                        
                        <tr>
                            <td style="width:100px"></td>
                              <td colspan="3">
                             <asp:RadioButtonList ID="rdbKetqua" runat="server" RepeatDirection="Horizontal" RepeatColumns="1">
                            <asp:ListItem Value="0" Text="Đã thực hiện xong phương án phục hồi kinh doanh được coi là không còn mất khả năng thanh toán"></asp:ListItem>
                            <asp:ListItem Value="1" Text="Không thực hiện được phương án phục hồi hoạt động kinh doanh"></asp:ListItem>
                            <asp:ListItem Value="2" Text="Hết thời hạn thực hiện phương án phục hồi hoạt động kinh doanh vẫn mất khả năng thanh toán"></asp:ListItem>                         
                        </asp:RadioButtonList>
                            </td>
                        </tr>
                           <tr>
                        <td colspan="4" style="text-align: center;">
                        <asp:Label runat="server" ID="lblthongbao2" ForeColor="Red"></asp:Label>
                            </td>
                    </tr>
                    <tr>
                        <td colspan="4" style="text-align: center;">
                            <asp:Button ID="btnKetqua" runat="server" CssClass="buttoninput" Text="Lưu kết quả" OnClick="btnKetqua_Click"  />
                         
                        </td>
                    </tr>
                        </table>
                    </div>
                </div>
            </div>
            </div>

   
</asp:Content>
