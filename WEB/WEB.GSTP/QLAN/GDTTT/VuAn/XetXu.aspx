<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="XetXu.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.XetXu" %>

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
            width: 80px;
        }

        .DonGDTCol4 {
            width: 160px;
        }

        .DonGDTCol5 {
            width: 70px;
        }
    </style>
    <asp:HiddenField ID="hddLoaiTK" runat="server" Value="" />
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2">
                            <div class="boxchung">
                                <h4 class="tleboxchung">Tìm kiếm
                                    <%--<asp:LinkButton ID="lbtTTTK" runat="server" Text="[ Nâng cao ]" ForeColor="#0E7EEE" OnClick="lbtTTTK_Click"></asp:LinkButton>--%></h4>
                                <div class="boder" style="padding: 10px;">
                                    <table class="table1">
                                        <tr>
                                            <td>Thụ lý XX từ</td>
                                            <td>
                                                <asp:TextBox ID="txtThuly_Tu" runat="server" CssClass="user" Width="222px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender8" runat="server" TargetControlID="txtThuly_Tu" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender8" runat="server" TargetControlID="txtThuly_Tu" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                            <td>Đến ngày</td>
                                            <td>
                                                <asp:TextBox ID="txtThuly_Den" runat="server" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender9" runat="server" TargetControlID="txtThuly_Den" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender9" runat="server" TargetControlID="txtThuly_Den" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                            <td>Số thụ lý</td>
                                            <td>
                                                <asp:TextBox ID="txtThuly_So" runat="server" CssClass="user" Width="152px" MaxLength="250"></asp:TextBox></td>
                                        </tr>
                                        <tr>
                                            <td class="DonGDTCol1">Tòa ra BA/QĐ</td>
                                            <td class="DonGDTCol2">
                                                <asp:DropDownList ID="ddlToaXetXu" CssClass="chosen-select" runat="server" Width="230px"></asp:DropDownList>
                                            </td>
                                            <td class="DonGDTCol3">Số BA/QĐ</td>
                                            <td class="DonGDTCol4">
                                                <asp:TextBox ID="txtSoQDBA" runat="server" CssClass="user" Width="152px" MaxLength="50"></asp:TextBox>
                                            </td>
                                            <td class="DonGDTCol5">Ngày BA/QĐ</td>
                                            <td>
                                                <asp:TextBox ID="txtNgayBAQD" runat="server" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtNgayBAQD" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtNgayBAQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblTitleBC" runat="server" Text="Nguyên đơn"></asp:Label></td>
                                            <td>
                                                <asp:TextBox ID="txtNguyendon" runat="server" CssClass="user" Width="222px" MaxLength="250"></asp:TextBox></td>
                                            <td>
                                                <asp:Label ID="lblTitleBD" runat="server" Text="Bị đơn"></asp:Label></td>
                                            <td>
                                                <asp:TextBox ID="txtBidon" runat="server" CssClass="user" Width="152px" MaxLength="250"></asp:TextBox>
                                            </td>
                                            <td>Loại án</td>
                                            <td>
                                                <asp:DropDownList ID="ddlLoaiAn" CssClass="chosen-select"
                                                    AutoPostBack="true" OnSelectedIndexChanged="ddlLoaiAn_SelectedIndexChanged"
                                                    runat="server" Width="160px">
                                                </asp:DropDownList>

                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Cán bộ giải quyết đơn
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlThamtravien" CssClass="chosen-select" runat="server" Width="230px">
                                                </asp:DropDownList>
                                            </td>
                                            <td>LĐ phụ trách</td>
                                            <td>
                                                <asp:DropDownList ID="ddlPhoVuTruong" CssClass="chosen-select" runat="server" Width="160px">
                                                </asp:DropDownList></td>
                                            <td>
                                                <asp:DropDownList ID="ddlLoaiThamPhan" runat="server" AutoPostBack="true" OnSelectedIndexChanged="Drop_LoaiThamPhan_SelectedIndexChanged">
                                                    <asp:ListItem Text="Tất cả thẩm phán" Value="0" />
                                                    <asp:ListItem Text="Thẩm phán tối cao" Value="1" />
                                                    <asp:ListItem Text="Thẩm phán bậc 3" Value="2" />
                                                </asp:DropDownList>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlThamphan" CssClass="chosen-select" runat="server" Width="160px"></asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Tình trạng
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="dropTrangThaiXXGDT"
                                                    AutoPostBack="true" OnSelectedIndexChanged="dropTrangThaiXXGDT_SelectedIndexChanged"
                                                    CssClass="chosen-select" runat="server" Width="230px">
                                                    <asp:ListItem Value="-1" Text="Tất cả"></asp:ListItem>
                                                    <asp:ListItem Value="2" Text="Chưa thụ lý"></asp:ListItem>
                                                    <asp:ListItem Value="0" Text="Đã thụ lý và chưa xét xử"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Đã xét xử"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td>Thẩm quyền XX</td>
                                            <td>
                                                <asp:DropDownList ID="dropThamQuyenXX"
                                                    CssClass="chosen-select" runat="server" Width="160px">
                                                </asp:DropDownList>
                                            </td>
                                            <td>Kết quả xét xử</td>
                                            <td>
                                                <asp:DropDownList ID="ddlKetquaXX" CssClass="chosen-select"
                                                    runat="server" Width="160px">
                                                </asp:DropDownList></td>
                                        </tr>
                                        <tr>
                                            <td>XX từ ngày</td>
                                            <td>
                                                <asp:TextBox ID="txtNgayXX_TuNgay" runat="server" CssClass="user" Width="222px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayXX_TuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayXX_TuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                            <td>Đến ngày</td>
                                            <td>
                                                <asp:TextBox ID="txtNgayXX_DenNgay" runat="server" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgayXX_DenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayXX_DenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                            <td>
                                                <asp:Panel ID="pnVKS_Nguoiky_lable" runat="server" Visible="false">
                                                    Đơn vị Kháng nghị
                                                </asp:Panel>

                                            </td>
                                            <td>
                                                <asp:Panel ID="pnVKS_Nguoiky" runat="server" Visible="false">
                                                    <asp:DropDownList ID="dropVKS_NguoiKy" CssClass="chosen-select"
                                                        runat="server" Width="160px">
                                                    </asp:DropDownList>
                                                </asp:Panel>

                                            </td>

                                        </tr>
                                        <tr>
                                            <td>Số Kháng nghị</td>
                                            <td>
                                                <asp:TextBox ID="txtSoKN" runat="server" CssClass="user" Width="222px" MaxLength="250"></asp:TextBox></td>
                                            <td>Ngày Kháng nghị</td>
                                            <td>
                                                <asp:TextBox ID="txtNgayKN" runat="server" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayKN" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgayKN" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                            <td>Loại BA GĐT</td>
                                            <td>
                                                <asp:DropDownList ID="ddlLoaiGDT" CssClass="chosen-select" runat="server" Width="160px">
                                                    <asp:ListItem Value="4" Text="--Tất cả--"></asp:ListItem>
                                                    <asp:ListItem Value="0" Text="Đơn đề nghị GĐT,TT"></asp:ListItem>
                                                    <asp:ListItem Value="2" Text="Rút Hồ sơ đoàn kiểm tra"></asp:ListItem>
                                                    <asp:ListItem Value="3" Text="Chủ động GĐT qua Bản án"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Kháng nghị của VKS"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Quá hạn luật định</td>
                                            <td>
                                                <asp:DropDownList ID="dropQuahan" CssClass="chosen-select" runat="server" Width="230px">
                                                    <asp:ListItem Value="-1" Text="--Tất cả--" Selected="True"></asp:ListItem>
                                                    <asp:ListItem Value="0" Text="Không quá hạn"></asp:ListItem>
                                                    <asp:ListItem Value="2" Text="Khách quan"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Chủ quan"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td>Áp dụng án lệ</td>
                                            <td>
                                                <asp:DropDownList ID="dropApdungAL" CssClass="chosen-select" runat="server" Width="160px">
                                                    <asp:ListItem Value="-1" Text="--Tất cả--" Selected="True"></asp:ListItem>
                                                    <asp:ListItem Value="0" Text="Không áp dụng Án lệ"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Áp dụng Án lệ"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td></td>
                                            <td></td>
                                        </tr>
                                        <tr>
                                            <td></td>
                                            <td align="left" colspan="3">
                                                <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                                                <asp:Button ID="cmdPrint" runat="server" CssClass="buttoninput" Text="In biểu mẫu" OnClick="cmdPrint_Click" />
                                                <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_Click" />
                                            </td>
                                            <td align="right" colspan="2">
                                                <%--<div>
                                                    <asp:Button ID="btnThemmoi" runat="server" CssClass="buttoninput" Text="Thêm mới vụ án chuyển HS kháng nghị VKS" OnClick="btnThemmoi_Click" />
                                                </div>--%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td></td>
                                            <td colspan="5">
                                                <%--<asp:DropDownList ID="dropBM" runat="server"  CssClass="chosen-select"></asp:DropDownList>--%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="6">
                                                <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label>
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
                                    <asp:DropDownList ID="ddlPageCount" runat="server" Width="55px" CssClass="so" Visible="false" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount_SelectedIndexChanged">
                                        <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                        <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                        <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                        <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                        <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                        <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <asp:DataGrid ID="gridHS" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan" Width="100%" OnItemDataBound="dgList_ItemDataBound"
                                OnItemCommand="dgList_ItemCommand">
                                <Columns>
                                    <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>TT</HeaderTemplate>
                                        <ItemTemplate><%#Eval("STT")%></ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="60px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Số & Ngày thụ lý</HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("SOTHULYDON")%>
                                            <br />
                                            <%#Eval("NGAYTHULYDON")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="120px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thông tin bản án</HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("InforBA")%>
                                            <%--<b><%#Eval("SOANPHUCTHAM")%></b>
                                            <br />
                                            <%#Eval("NGAYXUPHUCTHAM")%>
                                            <br />
                                            <%#Eval("TOAXX_VietTat")%>--%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:BoundColumn DataField="QHPNDN_Report" HeaderText="Tội danh" HeaderStyle-Width="120px"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="NGUYENDON" HeaderText="Bị cáo đầu vụ" HeaderStyle-Width="70px"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="BIDON" HeaderText="Bị cáo khiếu nại" HeaderStyle-Width="70px"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="NGUOIKHIEUNAI" HeaderText="Người khiếu nại" HeaderStyle-Width="90px"></asp:BoundColumn>

                                    <asp:TemplateColumn HeaderStyle-Width="150px" ItemStyle-HorizontalAlign="Justify" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Thẩm tra viên<br />
                                            Lãnh đạo Vụ<br />
                                            Thẩm phán
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%# String.IsNullOrEmpty(Eval("TENTHAMTRAVIEN")+"") ? 
                                                    ("<b style='margin-left:3px;'>TTV:"+Eval("TENTHAMTRAVIEN_GDT")+"</b><br />") : 
                                                    ("<b style='margin-left:3px;'>"+Eval("TENTHAMTRAVIEN")+"</b><br />")%>

                                            <%# String.IsNullOrEmpty(Eval("THAMPHANTC_TEN")+"")? "":("TPTC:<b style='margin-left:3px;'>"+Eval("THAMPHANTC_TEN")+"</b><br/>")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Kết quả giải quyết</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:Literal ID="lttLanTT" runat="server"></asp:Literal>
                                            <br />
                                            <asp:Literal ID="lttDetaiTinhTrang" runat="server"></asp:Literal>

                                            <asp:Literal ID="lttKQGQ" runat="server"></asp:Literal>
                                            <div style="width: 100%; float: left; bottom: 0px;">
                                                <div style="float: left; width: 99%; margin-top: 8px;">
                                                    <asp:LinkButton ID="cmdKetqua" runat="server" Font-Bold="true" ForeColor="#0e7eee" CommandArgument='<%#Eval("ID") %>' CommandName="KETQUA" Text="Cập nhật kết quả"></asp:LinkButton>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                </Columns>
                                <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            </asp:DataGrid>
                            <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan" Width="100%" OnItemDataBound="dgList_ItemDataBound"
                                OnItemCommand="dgList_ItemCommand">
                                <Columns>
                                    <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>TT</HeaderTemplate>
                                        <ItemTemplate><%#Eval("STT")%></ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="60px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Số & Ngày thụ lý</HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("SOTHULYDON")%>
                                            <br />
                                            <%#Eval("NGAYTHULYDON")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="120px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thông tin bản án</HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("InforBA")%>
                                            <%--<b><%#Eval("SOANPHUCTHAM")%></b>
                                            <br />
                                            <%#Eval("NGAYXUPHUCTHAM")%>
                                            <br />
                                            <%#Eval("TOAXX_VietTat")%>--%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:BoundColumn DataField="QHPLDN" HeaderText="Quan hệ pháp luật" HeaderStyle-Width="70px"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="NGUYENDON" HeaderText="Nguyên đơn/ Người khởi kiện" HeaderStyle-Width="90px"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="BIDON" HeaderText="Bị đơn/ Người bị kiện" HeaderStyle-Width="90px"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="NGUOIKHIEUNAI" HeaderText="Người khiếu nại" HeaderStyle-Width="90px"></asp:BoundColumn>

                                    <asp:TemplateColumn HeaderStyle-Width="150px" ItemStyle-HorizontalAlign="Justify" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Thẩm tra viên<br />
                                            Lãnh đạo Vụ<br />
                                            Thẩm phán
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%# String.IsNullOrEmpty(Eval("TENTHAMTRAVIEN")+"") ? 
                                                    ("<b style='margin-left:3px;'>TTV:"+Eval("TENTHAMTRAVIEN_GDT")+"</b><br />") : 
                                                    ("<b style='margin-left:3px;'>"+Eval("TENTHAMTRAVIEN")+"</b><br />")%>

                                            <%# String.IsNullOrEmpty(Eval("THAMPHANTC_TEN")+"")? "":("TPTC:<b style='margin-left:3px;'>"+Eval("THAMPHANTC_TEN")+"</b><br/>")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Kết quả giải quyết</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:Literal ID="lttLanTT" runat="server"></asp:Literal>
                                            <br />
                                            <asp:Literal ID="lttDetaiTinhTrang" runat="server"></asp:Literal>

                                            <asp:Literal ID="lttKQGQ" runat="server"></asp:Literal>
                                            <div style="width: 100%; float: left; bottom: 0px;">
                                                <div style="float: left; width: 99%; margin-top: 8px;">
                                                    <asp:LinkButton ID="cmdKetqua" runat="server" Font-Bold="true" ForeColor="#0e7eee" CommandArgument='<%#Eval("ID") %>' CommandName="KETQUA" Text="Cập nhật kết quả"></asp:LinkButton>
                                                </div>
                                            </div>
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
                                    <asp:DropDownList ID="ddlPageCount2" runat="server" Width="55px" CssClass="so" Visible="false" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount2_SelectedIndexChanged">
                                        <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                        <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
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
        function LoadDsDon() {
            $("#<%= cmdTimkiem.ClientID %>").click();
        }

    </script>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
</asp:Content>

