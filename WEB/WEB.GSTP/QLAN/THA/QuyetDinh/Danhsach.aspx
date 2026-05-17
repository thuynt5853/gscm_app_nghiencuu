<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Danhsach.aspx.cs" Inherits="WEB.GSTP.QLAN.THA.QuyetDinh.Danhsach" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <style>.boxchung{float:left;width:99%; margin-left:0;}</style>
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
                                            <td style="width: 75px;">Trạng thái</td>
                                            <td>
                                                <asp:RadioButtonList ID="rdChucVuDang" runat="server" RepeatDirection="Horizontal">
                                                    <asp:ListItem Selected="True" Value="0">Chưa ra quyết định</asp:ListItem>
                                                    <asp:ListItem Value="1">Đã ra quyết định</asp:ListItem>
                                                </asp:RadioButtonList></td>
                                        </tr>
                                        <tr>
                                            <td style="width: 100px;">Từ khóa</td>
                                            <td>
                                                <asp:TextBox ID="txtTextSearch" CssClass="user" runat="server" Width="98%"></asp:TextBox>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 150px;" align="left"></td>
                        <td align="left">
                            <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                            <asp:Button ID="cmdThemmoi" runat="server" CssClass="buttoninput" Text="Thêm mới" OnClick="btnThemmoi_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="left">
                            <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>
                    <%-- <tr>
                        <td colspan="2" align="left">
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
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
                                </div>
                            </div>
                            <!--------------------------------------->
                            <asp:Repeater ID="rpt" runat="server"
                                OnItemCommand="rpt_ItemCommand" OnItemDataBound="rpt_ItemDataBound">
                                <HeaderTemplate>
                                    <table class="table2" width="100%" border="1">
                                        <tr class="header">
                                            <td width="42">
                                                    <div align="center"><strong>TT</strong></div>
                                                </td>
                                                <td>
                                                    <div align="center"><strong>Tên bộ luật</strong></div>
                                                </td>
                                                <td width="10%">
                                                    <div align="center"><strong>Ngày ban hành</strong></div>
                                                </td>
                                             

                                                <td width="10%">
                                                    <div align="center"><strong>Nguời tạo</strong></div>
                                                </td>
                                                <td width="10%">
                                                    <div align="center"><strong>Ngày tạo</strong></div>
                                                </td>
                                                   <td width="15%">
                                                    <div align="center"><strong>Điều khoản</strong></div>
                                                </td>
                                            <td width="70">
                                                <div align="center"><strong>Thao tác</strong></div>
                                            </td>
                                        </tr>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                       <td><%# Eval("STT") %></td>
                                            <td><%#Eval("TenBoLuat") %></td>

                                            <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NgayBanHanh")) %></td>
                                           
                                            <td><%# Eval("NguoiTao") %></td>
                                            <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NgayTao")) %></td>
                                             <td align="center">
                                                <asp:LinkButton ID="lkToiDanh" runat="server" Text="Danh sách tội danh"
                                                    CausesValidation="false" CommandName="toidanh" ForeColor="#0e7eee"
                                                    CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>

                                            </td>
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
                            <!--------------------------------------->
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active" Visible="false"
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
                                </div>
                            </div>
                        </td>
                    </tr>--%>
                    <tr>
                        <td colspan="2">

                            <div class="phantrang">
                                <div class="sobanghi">
                                    Có <b>3 </b>bản ghi trong <b>1</b> trang
                               
                                </div>
                                <div class="sotrang">
                                </div>
                            </div>
                            <div>
                                <table class="table2" width="100%" border="1">
                                    <tbody>
                                        <tr class="header">
                                            <td width="42">
                                                <div align="center"><strong>TT</strong></div>
                                            </td>

                                            <td width="60">
                                                <div align="center"><strong>Số thụ lý</strong></div>
                                            </td>
                                            <td width="70">
                                                <div align="center"><strong>Ngày thụ lý</strong></div>
                                            </td>
                                            <td>
                                                <div align="center"><strong>Bị án</strong></div>
                                            </td>
                                            <td width="80">
                                                <div align="center"><strong>Số QĐ</strong></div>
                                            </td>
                                            <td width="70">
                                                <div align="center"><strong>Ngày ra QĐ</strong></div>
                                            </td>
                                            <td>
                                                <div align="center"><strong>Nơi chấp hành án</strong></div>
                                                <td width="70">
                                                    <div align="center"><strong>Thao tác</strong></div>
                                                </td>
                                        </tr>

                                        <tr>
                                            <td>1</td>
                                            <td>010011</td>
                                            <td>16/03/2018</td>
                                            <td>Nguyễn Văn A</td>
                                            <td>45513/2018</td>
                                            <td>16/03/2018</td>
                                            <td></td>
                                            <td>
                                                <div align="center">
                                                    <a href="javascript:__doPostBack('ctl00$ContentPlaceHolder1$rpt$ctl01$lblSua','')" style="color: #0E7EEE;">Sửa</a>
                                                    &nbsp;&nbsp;<a onclick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');" id="ContentPlaceHolder1_rpt_lbtXoa_0" title="Xóa" href="javascript:__doPostBack('ctl00$ContentPlaceHolder1$rpt$ctl01$lbtXoa','')" style="color: #0E7EEE;">Xóa</a>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>2</td>
                                            <td>010012</td>
                                            <td>16/03/2018</td>
                                            <td>Nguyễn Văn B</td>
                                            <td>45523/2018</td>
                                            <td>16/03/2018</td>
                                            <td></td>
                                            <td>
                                                <div align="center">
                                                    <a href="javascript:__doPostBack('ctl00$ContentPlaceHolder1$rpt$ctl01$lblSua','')" style="color: #0E7EEE;">Sửa</a>
                                                    &nbsp;&nbsp;<a onclick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');" id="ContentPlaceHolder1_rpt_lbtXoa_0" title="Xóa" href="javascript:__doPostBack('ctl00$ContentPlaceHolder1$rpt$ctl01$lbtXoa','')" style="color: #0E7EEE;">Xóa</a>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="phantrang">
                                <div class="sobanghi">
                                    Có <b>3 </b>bản ghi trong <b>1</b> trang
                               
                                </div>
                                <div class="sotrang">
                                </div>
                            </div>

                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
