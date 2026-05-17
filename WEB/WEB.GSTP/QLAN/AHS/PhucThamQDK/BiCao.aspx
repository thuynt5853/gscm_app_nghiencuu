<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master"
    AutoEventWireup="true" CodeBehind="BiCao.aspx.cs" Inherits="WEB.GSTP.QLAN.AHS.PhucThamQDK.BiCao" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div style="margin: 5px; text-align: center; width: 95%">
        <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput"
            Text="Lưu" OnClick="cmdUpdate_Click" />
    </div>
    <div style="margin: 5px; text-align: center; width: 95%; color: red;">
        <asp:Literal ID="lstMsgT" runat="server"></asp:Literal>
    </div>
    <div class="box">
        <div class="box_nd">
            <div>
                <div class="boxchung">
                    <h4 class="tleboxchung">Danh sách bị can tham gia phúc thẩm</h4>
                    <div class="boder" style="padding: 10px;">
                        <asp:HiddenField ID="hddBiCanPhucTham" runat="server" />
                        <table class="table2" width="100%" border="1">
                            <tr class="header">
                                <td width="80">
                                    <div align="center">Tham gia phúc thẩm</div>
                                </td>
                                <td width="25%">
                                    <div align="center"><strong>Bị cáo</strong></div>
                                </td>
                                <td width="70px">
                                    <div align="center"><strong>Năm sinh</strong></div>
                                </td>
                              
                                <%--<td> <div align="center"><strong>Tội danh</strong></div></td>
                                 <td> <div align="center"><strong>Hình phạt</strong></div></td>--%>
                                <td width="90px"><div align="center"><strong>Kháng cáo?</strong></div></td>

                                <td>
                                    <div align="center"><strong>Địa chỉ tạm trú</strong></div>
                                </td>
                                <td width="10%">
                                    <div align="center"><strong>Bị can đầu vụ</strong></div>
                                </td>
                                <td width="20%">
                                    <div align="center"><strong>Tội danh chính</strong></div>
                                </td>
                            </tr>
                            <asp:Repeater ID="rpt" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <asp:HiddenField ID="hdd" runat="server" Value='<%#Eval("BiCaoID") %>' />
                                           <div align="center"> <asp:CheckBox ID="chkChange" runat="server" Checked='<%# (Convert.ToInt16(Eval("IsPhucTham"))>0)? true:false %>' /></div>
                                        </td>
                                        <td><%#Eval("TenBiCao") %></td>
                                        <td><%# Eval("NamSinh") %></td>
                                      
                                        <!------------------------>
                                       <%-- <td><%# Eval("NamSinh") %></td>
                                         <td><%# Eval("NamSinh") %></td>--%>
                                         <td><div align="center">
                                                <asp:CheckBox ID="chkIsKhangCao" runat="server" Enabled="false" Checked='<%# (Convert.ToInt16(Eval("IsKhangCao"))>0)? true:false %>' />
                                            </div></td>
                                         <!------------------------>
                                        <td><%# Eval("DCTamTru") %></td>
                                        <td>
                                            <div align="center">
                                                <asp:CheckBox ID="chk" runat="server" Enabled="false" Checked='<%# (Convert.ToInt16(Eval("BICANDAUVU"))>0)? true:false %>' />
                                            </div>
                                        </td>
                                        <td><%# Eval("TenToiDanh") %></td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </table>
                    </div>
                </div>
            </div>
            <div style="margin: 5px; text-align: center; width: 95%">
                <asp:Button ID="cmdUpdateBottom" runat="server" CssClass="buttoninput"
                    Text="Lưu" OnClick="cmdUpdate_Click" />
            </div>
        </div>
    </div>

</asp:Content>
