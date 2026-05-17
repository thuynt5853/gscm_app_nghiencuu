<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Danhsach.aspx.cs" Inherits="WEB.GSTP.Danhmuc.HinhPhat.Danhsach" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <script src="../../UI/js/Common.js"></script>

    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <style type="text/css">
        .tdWidthTblToaAn {
            width: 120px;
        }
    </style>
    <div class="box">
        <div class="box_nd">
            <div class="boder" style="float:left;width:98%;margin-bottom:10px;">
                <table class="table1">
                    <tr>
                        <td class="tdWidthTblToaAn"><b>Nhóm hình phạt</b>
                            <span class="must_input">(*)</span></td>
                        <td colspan="3">
                            <asp:DropDownList ID="dropNhomHinhPhat" runat="server" CssClass="user"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td class="tdWidthTblToaAn"><b>Mã</b>
                           </td>
                        <td style="width: 150px;">
                            <asp:TextBox ID="txtMa" CssClass="user" runat="server" Width="80%"></asp:TextBox>
                        </td>
                        <td style="width:80px;"><b>Loại giá trị</b>
                            <span class="must_input">(*)</span></td>
                        <td>
                            <asp:DropDownList ID="dropLoaiHinhPhat" CssClass="user" runat="server" Width="150px" />

                        </td>
                    </tr>
                    <tr>
                        <td class="tdWidthTblToaAn"><b>Tên hình phạt<span class="must_input">(*)</span></b></td>
                        <td colspan="3">
                            <asp:TextBox ID="txtTen" CssClass="user" runat="server" Width="80%"></asp:TextBox>

                        </td>
                    </tr>
                    <tr>
                        <td class="tdWidthTblToaAn"><b>Mô tả</b></td>
                        <td colspan="3">
                            <asp:TextBox ID="txtMoTa" CssClass="user" runat="server" Width="81%" TextMode="MultiLine" Rows ="5"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="tdWidthTblToaAn"><b>Án treo</b></td>
                        <td >
                           <asp:RadioButtonList ID="rdAnTreo" runat="server"
                                                        RepeatDirection="Horizontal" >
                                                        <asp:ListItem Value="0">Không</asp:ListItem>
                                                        <asp:ListItem Value="1">Có</asp:ListItem>
                                                    </asp:RadioButtonList>
                        </td>
                        <td style="text-align:right;"><b>Thứ tự</b></td>
                        <td>
                            <asp:TextBox ID="txtThuTu" runat="server" Width="50px" CssClass="user align_right" onkeypress="return isNumber(event)"></asp:TextBox>
                        </td>
                    </tr>
                     <tr>
                        <td class="tdWidthTblToaAn"><b>Hiệu lực</b></td>
                        <td colspan="3">
                          <asp:RadioButtonList ID="rdHieuLuc" runat="server"
                                                        RepeatDirection="Horizontal" >
                                                        <asp:ListItem Value="0">Không</asp:ListItem>
                                                        <asp:ListItem Value="1">Có</asp:ListItem>
                                                    </asp:RadioButtonList>
                        </td>
                    </tr>
                      
                    <tr>
                        <td colspan="4"></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="3">
                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu"
                                OnClick="btnUpdate_Click" OnClientClick="return Validate()" />
                            <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />
                        </td>
                    </tr>
                </table>
            </div>
             <div style="float:left; width:100%;">
                   <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                                <asp:HiddenField ID="hddCurrID" runat="server" Value="0" />
                              
                            </div>
                            <table style="width: 100%; margin-top: 25px;">
                                <tr>
                                    <td colspan="2">
                                        <asp:TextBox runat="server" ID="txttimkiem" Width="30%" CssClass="user"></asp:TextBox>
                                        <asp:DropDownList ID="dropHieuLuc" runat="server" CssClass="user"></asp:DropDownList>
                                         <asp:DropDownList ID="dropNhom" runat="server" CssClass="user"></asp:DropDownList>

                                        <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm"
                                            OnClick="Btntimkiem_Click" />
                                    </td>
                                </tr>
                            </table>
                            <asp:Panel runat="server" ID="pndata" Visible="false">
                                <div class="phantrang">
                                    <div class="sobanghi">
                                        <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                    </div>
                                    <div class="sotrang">
                                        <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                                            OnClick="lbTBack_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
                                            Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                        <asp:Label ID="lbTStep1" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so"
                                            Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so"
                                            Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so"
                                            Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so"
                                            Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:Label ID="lbTStep6" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so"
                                            Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next"
                                            OnClick="lbTNext_Click"></asp:LinkButton>
                                    </div>
                                </div>
                                <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand" OnItemDataBound="rpt_ItemDataBound">
                                    <HeaderTemplate>
                                        <table class="table2" width="100%" border="1">
                                            <tr class="header">
                                                <td width="42">
                                                    <div align="center"><strong>TT</strong></div>
                                                </td>
                                                
                                                <td>
                                                    <div align="center"><strong>Tên hình phạt</strong></div>
                                                </td>
                                                <td width="10%">
                                                    <div align="center"><strong>Nguời tạo</strong></div>
                                                </td>
                                                <td width="10%">
                                                    <div align="center"><strong>Ngày tạo</strong></div>
                                                </td>
                                                <td width="70">
                                                    <div align="center"><strong>Thao tác</strong></div>
                                                </td>
                                            </tr>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr>
                                            <td><div align="center"><%# Eval("STT") %></div></td>
                                           
                                            <td><%#Eval("TENHINHPHAT") %></td>

                                           
                                            <td><%# Eval("NguoiTao") %></td>
                                            <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NgayTao")) %></td>
                                            <td>
                                                <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                                    CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>

                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                    <FooterTemplate></table></FooterTemplate>
                                </asp:Repeater>

                                <div class="phantrang">
                                    <div class="sobanghi">
                                        <asp:HiddenField ID="hdicha" runat="server" />
                                        <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                    </div>
                                    <div class="sotrang">
                                        <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back"
                                            OnClick="lbTBack_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active"
                                            Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                        <asp:Label ID="lbBStep1" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so"
                                            Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so"
                                            Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so"
                                            Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so"
                                            Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:Label ID="lbBStep6" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so"
                                            Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next"
                                            OnClick="lbTNext_Click"></asp:LinkButton>
                                    </div>
                                </div>
                            </asp:Panel>
        </div>
    </div>
    <script>
        function Validate() {   
            var dropNhomHinhPhat = document.getElementById('<%=dropNhomHinhPhat.ClientID%>');
            var value_change = dropNhomHinhPhat.options[dropNhomHinhPhat.selectedIndex].value;
            if (value_change == "") {
                alert('Bạn chưa chọn nhóm hình phạt. Hãy kiểm tra lại!');
                dropNhomHinhPhat.focus();
                return false;
            }
           var dropLoaiHinhPhat = document.getElementById('<%=dropLoaiHinhPhat.ClientID%>');
           value_change = dropLoaiHinhPhat.options[dropLoaiHinhPhat.selectedIndex].value;
            if (value_change == "")
            {
                alert('Bạn chưa chọn loại giá trị. Hãy kiểm tra lại!');
                dropLoaiHinhPhat.focus();
                return false;
            }

            var txtTen = document.getElementById('<%=txtTen.ClientID%>');
            if (!Common_CheckEmpty(txtTen.value)) {
                alert('Bạn chưa nhập tên hình phạt. Hãy kiểm tra lại!');
                txtTen.focus();
                return false;
            }

            //------------------------
            var rdAnTreo = document.getElementById('<%=rdAnTreo.ClientID%>');
            msg = 'Mục "Án treo" bắt buộc phải chọn.';
            msg += 'Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdAnTreo, msg))
                return false;
            //---------------------
            var rdHieuLuc = document.getElementById('<%=rdHieuLuc.ClientID%>');
            msg = 'Mục "Hiệu lực" bắt buộc phải chọn.';
            msg += 'Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdHieuLuc, msg))
                return false;
            return true;
        }
    </script>
</asp:Content>
