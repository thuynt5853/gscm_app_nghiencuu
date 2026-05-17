<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" 
CodeBehind="Danhsach.aspx.cs" Inherits="WEB.GSTP.QTDKK.Trangtinh.Danhsach" %>

<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <script src="../../UI/js/Common.js"></script>

    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td style="width: 120px;"><b>Mã trang<span class="must_input">(*)</span></b>
                        </td>
                        <td>
                            <asp:TextBox ID="txtMa" CssClass="user" runat="server" Width="20%" MaxLength="50"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Tên trang<span class="must_input">(*)</span></b></td>
                        <td>
                            <asp:TextBox ID="txtTen" CssClass="user" runat="server" Width="98%" MaxLength="250"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Nội dung<span class="must_input">(*)</span></b></td>
                        <td>
                            <CKEditor:CKEditorControl ID="txtNoiDung"
                                BasePath="/UI/Tools/ckeditor/"
                                runat="server" Width="98%" Height="200px"></CKEditor:CKEditorControl>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput"
                                Text="Cập nhật"  CausesValidation="false"
                                OnClick="btnUpdate_Click" OnClientClick="return Validate()" />
                            <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput"
                                Text="Làm mới" OnClick="btnLammoi_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                                <asp:HiddenField ID="hddCurrID" runat="server" Value="0" />
                                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                            
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
                                <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand"
                                    OnItemDataBound="rpt_ItemDataBound">
                                    <HeaderTemplate>
                                        <table class="table2" style="width:100%;" border="1">
                                            <tr class="header">
                                                <td style="width:42px">
                                                    <div style ="font-weight:bold; text-align:center;">TT</div>
                                                </td>
                                                <td  style="width:120px">
                                                    <div style ="font-weight:bold; text-align:center;">Mã trang</div>
                                                </td>
                                                <td  >
                                                    <div style ="font-weight:bold; text-align:center;">Tên trang</div>
                                                </td>
                                               
                                                <td style="width:70px">
                                                    <div style ="font-weight:bold; text-align:center;">Thao tác</div>
                                                </td>
                                            </tr>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr>
                                            <td><%# Eval("STT") %></td>
                                            <td><%#Eval("MATRANG") %></td>
                                            <td><%#Eval("TENTRANG") %></td>
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
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script>
        function Validate() {
            var txtMa = document.getElementById('<%=txtMa.ClientID%>');
            if (!Common_CheckEmpty(txtMa.value)) {
                alert('Bạn chưa nhập mã trang. Hãy kiểm tra lại!');
                txtMa.focus();
                return false;
            }
            var txtTen = document.getElementById('<%=txtTen.ClientID%>');
            if (!Common_CheckEmpty(txtTen.value)) {
                alert('Bạn chưa nhập tên trang. Hãy kiểm tra lại!');
                txtTen.focus();
                return false;
            }
            var txtNoiDung = CKEDITOR.instances.<%=txtNoiDung.ClientID%>;
            if (!Common_CheckEmpty(txtNoiDung.getData())) {
                alert('Bạn chưa nhập nội dung trang. Hãy kiểm tra lại!');
                txtNoiDung.focus();
                return false;
            }
            return true;
        }
    </script>
</asp:Content>
