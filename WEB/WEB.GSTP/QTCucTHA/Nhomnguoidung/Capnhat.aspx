<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Capnhat.aspx.cs" Inherits="WEB.GSTP.QTCucTHA.Nhomnguoidung.Capnhat" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="box">
  
    <div class="box_nd">
        <div class="truong">
            <table class="table1">
                <tr>
                    <td style="width: 150px;" align="left">
                        <b>Đơn vị</b>
                    </td>
                    <td align="left">
                        <asp:DropDownList  CssClass="chosen-select"  ID="ddlDonvi" runat="server" Width="500px">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="width: 150px;" align="left">
                         <b>Tên nhóm</b> <asp:Label runat="server" ID="nhap" Text="(*)" ForeColor="Red"></asp:Label>
                    </td>
                    <td align="left">
                          <asp:TextBox ID="txtTennhom" CssClass="user" runat="server" Width="90%" 
                              MaxLength="250"></asp:TextBox>
                    </td>
                </tr>
                <tr >
                    <td style="width: 150px;" align="left">
                        <b>Hỗ trợ cấp dưới</b>
                    </td>
                    <td align="left">
                        <asp:DropDownList  CssClass="chosen-select"  ID="ddlLoaiNhom" runat="server" Width="500px">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="width: 150px;" align="left">
                         <b>Ghi chú</b>
                    </td>
                    <td align="left">
                          <asp:TextBox ID="txtGhichu" CssClass="user" runat="server" Width="90%" 
                              MaxLength="250"></asp:TextBox>
                    </td>
                </tr>
             </table>
             </div>
             <table class="table1">
                
                
                <tr>
                    
                    <td style="text-align:center;">
                        <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                    </td>
                </tr>
                <tr>
                   
                    <td style="text-align:center;">
                          <asp:Button ID="cmdCapnhat" runat="server" cssclass="buttoninput" Text="Lưu"  OnClick="btnUpdate_Click" OnClientClick="return kiemtra()"  />
                                
                          <asp:Button ID="cmdQuaylai" runat="server" cssclass="buttoninput" Text="Quay lại"  onclick="lblquaylai_Click"  />
                           

                    </td>
                </tr>
            </table>
        </div>
    </div>
</div>
<script language="javascript" type="text/javascript">
    function kiemtra() {
        var txtTennhom = document.getElementById('<%=txtTennhom.ClientID %>');

        if (txtTennhom.value.trim() == "" || txtTennhom.value.trim() == null) {
            alert('Chưa nhập tên nhóm');
            txtTennhom.focus();
            return false;
        }

        return true;
    }
</script>
</asp:Content>
