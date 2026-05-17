<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="PhancongTP.aspx.cs" Inherits="WEB.GSTP.QLAN.AHC.Thamphan.PhancongTP" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddNgayThuLy" Value="" runat="server" />
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
                                            <td>
                                                <div style="float: left; width: 1050px">
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Tên vụ án</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtTenVuViec" CssClass="user" runat="server" Width="240px"></asp:TextBox>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Quan hệ pháp luật</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txt_QHPL" CssClass="user" runat="server" Width="238px"></asp:TextBox>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Mã vụ án</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtMaVuViec" CssClass="user" runat="server" Width="242px" MaxLength="50"></asp:TextBox>
                                                    </div>
                                                </div>
                                                <div style="float: left; width: 1050px; margin-top: 8px;">
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Đương sự</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtTENDUONGSU" CssClass="user" runat="server" Width="240px" MaxLength="50"></asp:TextBox>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Cấp xét xử</div>
                                                    <div style="float: left;">
                                                         <asp:DropDownList ID="dropCapxx" CssClass="chosen-select" runat="server" Width="246px"
                                                          AutoPostBack="True" OnSelectedIndexChanged="dropCapxx_SelectedIndexChanged"  ></asp:DropDownList>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Tòa xx sơ thẩm</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="DropToaAn" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="DropToaAn_SelectedIndexChanged"></asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div style="float: left; width: 1050px; margin-top: 4px;">
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Số BA/QĐ </div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtSoQD" CssClass="user" runat="server" Width="70px"></asp:TextBox>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Ngày BA/QĐ</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txt_NgayQD" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txt_NgayQD" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txt_NgayQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                        <cc1:MaskedEditValidator ID="MaskedEditValidator5" runat="server" ControlExtender="MaskedEditExtender5" ControlToValidate="txt_NgayQD" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                    </div>
                                                    <div style="float: left; width: 65px; text-align: right; margin-right: 10px;">Ngày thụ lý</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txt_NGAYTHULY_TU" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txt_NGAYTHULY_TU" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txt_NGAYTHULY_TU" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                        <cc1:MaskedEditValidator ID="MaskedEditValidator4" runat="server" ControlExtender="MaskedEditExtender4" ControlToValidate="txt_NGAYTHULY_TU" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                    </div>
                                                    <div style="float: left; width: 65px; text-align: right; margin-right: 10px;">Đến ngày</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txt_NGAYTHULY_DEN" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txt_NGAYTHULY_DEN" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txt_NGAYTHULY_DEN" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                        <cc1:MaskedEditValidator ID="MaskedEditValidator3" runat="server" ControlExtender="MaskedEditExtender3" ControlToValidate="txt_NGAYTHULY_DEN" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                    </div>
                                                    <div style="float: left; width: 65px; text-align: right; margin-right: 10px;">Số Thụ lý</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtSOTHULY" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                    </div>
                                                </div>
                                                <div style="float: left; width: 1050px; margin-top: 8px;">

                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Thẩm phán</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="ddlThamphan" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                                        <asp:HiddenField ID="hddLoaiTK" runat="server" Value="" />
                                                    </div>
                                                    <div style="float: left; width: 75px; text-align: right; margin-right: 10px;">Thư ký</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="ddlHTND_Thuky" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div style="float: left; width: 1050px; margin-top: 10px;">
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 5px;">Tình trạng</div>
                                                    <div style="float: left;">
                                                        <asp:RadioButtonList ID="rdbTrangthai" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rdbTrangthai_SelectedIndexChanged">
                                                            <asp:ListItem Value="2" Text="Chưa phân công TP" Selected="True"></asp:ListItem>
                                                            <asp:ListItem Value="3" Text="Đã phân công TP"></asp:ListItem>
                                                        </asp:RadioButtonList>
                                                    </div>
                                                    <div style="float: left; width: 55px; text-align: right; margin-right: 10px;">Từ ngày </div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtTuNgay" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="txtTuNgay_CalendarExtender" runat="server" TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                        <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtTuNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                    </div>
                                                    <div style="float: left; width: 65px; text-align: center; margin-right: 10px;">Đến ngày</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                        <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender2" ControlToValidate="txtDenNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 150px;" align="left">
                                                <div style="margin-top: 20px; margin-left: 200px;">
                                                    <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                                                    <asp:Button ID="cmdLamMoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLamMoi_Click" />
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="left">
                            <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red" Font-Size="17px"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="left">
                            <div class="phantrang">
                                <div class="sobanghi" style="width: 270px;">
                                    <asp:Button ID="cmdUpdate" ToolTip="Lưu kết quả phân công"
                                        runat="server" CssClass="buttoninput" Text="Lưu phân công"
                                        Height="26px" OnClick="cmdUpdate_Click" />
                                    <asp:Button ID="cmdPrint" runat="server" CssClass="buttoninput"
                                        Text="In danh sách" OnClick="cmdPrint_Click" />
                                </div>
                                <div class="sotrang">
                                    <div style="float: left; width: 100%">
                                        <div style="margin-left: 10px; float: right;">
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
                                                <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                                <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                                <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                                <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                                <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                                <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                        <div style="float: right;">
                                            <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div>
                                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%"
                                    OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                    <Columns>
                                        <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="THAMPHANGQ_ID" Visible="false"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="15px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>STT</HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("STT")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="30px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Chọn</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:HiddenField ID="hddCurrID" runat="server" Value='<%#Eval("ID")%>' />
                                                <asp:CheckBox ID="chkChon" runat="server" AutoPostBack="true" ToolTip='<%#Eval("ID")%>' OnCheckedChanged="chkChon_CheckedChanged" />
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center" Width="30px"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify">
                                            <HeaderTemplate>
                                                Thông tin vụ án
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <i style='margin-right: 3px;'>Tên vụ án:</i>  <b><%#Eval("TENVUVIEC")%></b>
                                                <br />
                                                <i style='margin-right: 3px;'>Mã vụ án:</i>  <b><%#Eval("MAVUVIEC")%></b>
                                                <br />
                                                <i style='margin-right: 3px;'>Cấp xét xử:</i>  <b><%#Eval("GiaiDoanVuViec")%></b>
                                                <%#Eval("TruongHopGiaoNhan")%>
                                                <%# Eval("TENTOASOTHAM")%>
                                                <%#Eval("BANAN_QD_ST")%>
                                                <%#Eval("HoTenBiCan")%>
                                                <%#Eval("KHANGNGHI_ST")%>
                                                <asp:Literal ID="lttThongTin" runat="server"></asp:Literal>
                                                <asp:HiddenField ID="hddCHECK_THULY" runat="server" Value='<%#Eval("CHECK_THULY")%>' />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="80px">
                                            <HeaderTemplate>
                                                Ngày nhận phân công<br />
                                                / Thẩm phán
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <div style="text-align: center;">
                                                    <asp:Label runat="server" ID="lbtthongbao_02" ForeColor="Red" Font-Size="13px"></asp:Label>
                                                </div>
                                                <div style="text-align: left;">
                                                    <asp:HiddenField ID="hddNgayPhanCongTP" runat="server" Value='<%#Eval("NGAYPHANCONGTP")%>' />
                                                    <asp:TextBox ID="txtNgayPhanCongTP" runat="server" CssClass="user" Width="172px"
                                                        MaxLength="10" placeholder="Ngày nhận phân công ..../..../....." Text='<%#Eval("NGAYPHANCONGTP") %>'></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CE_PCTTV" runat="server" TargetControlID="txtNgayPhanCongTP" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="ME__PCTTV" runat="server" TargetControlID="txtNgayPhanCongTP" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </div>
                                                <div style="margin-top: 10px; text-align: left;">
                                                    <asp:HiddenField ID="hddThamphan" runat="server" Value='<%#Eval("THAMPHAN_ID")%>' />
                                                    <asp:DropDownList ID="ddlThamphan_DG" CssClass="chosen-select" runat="server" Width="180"></asp:DropDownList>
                                                </div>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center" Width="80px"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                        </asp:TemplateColumn>

                                        <asp:TemplateColumn ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="80px">
                                            <HeaderTemplate>
                                                Ngày phân công
                                                <br />
                                                / Người phân công
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <div style="text-align: center;">
                                                    <asp:Label runat="server" ID="lbtthongbao_03" ForeColor="Red" Font-Size="13px"></asp:Label>
                                                </div>
                                                <div style="text-align: left;">
                                                    <asp:HiddenField ID="hddNgayPhanCongLD" runat="server" Value='<%#Eval("NGAYPHANCONGLD")%>' />
                                                    <asp:TextBox ID="txtNgayPhanCongLD" runat="server" CssClass="user" AutoPostBack="true" OnTextChanged="txtNgayPhanCongLD_TextChanged"
                                                        Width="172px" MaxLength="10" placeholder="Ngày phân công ..../..../....."
                                                        Text='<%#Eval("NGAYPHANCONGLD") %>'></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CE_PCLD" runat="server" TargetControlID="txtNgayPhanCongLD" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="ME_PCLD" runat="server" TargetControlID="txtNgayPhanCongLD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </div>
                                                <div style="margin-top: 10px; text-align: left;">
                                                    <asp:HiddenField ID="hdd_LDV" runat="server" Value='<%#Eval("LANHDAO_ID")%>' />
                                                    <asp:DropDownList CssClass="chosen-select" ID="ddlLDV" runat="server" Width="180px">
                                                    </asp:DropDownList>
                                                </div>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center" Width="80px"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="100px">
                                            <HeaderTemplate>
                                                Tình trạng GQ
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <div>
                                                    <%#Eval("TINHTRANG_GQ") %><br />
                                                </div>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="left"></ItemStyle>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left" HeaderStyle-Width="65px">
                                            <HeaderTemplate>
                                                Người tạo
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("NGUOITAO")%>
                                                <br />
                                                <%#Eval("NGAYTAO")%>
                                                <div style="margin-top: 10px; text-align: center;">
                                                    <asp:Button ID="cmdChitiet" runat="server" Text="Chọn vụ án"
                                                        CssClass="buttonchitiet"
                                                        CausesValidation="false" CommandName="Select" CommandArgument='<%#Eval("ID") %>' />
                                                </div>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                        </asp:TemplateColumn>
                                    </Columns>
                                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                </asp:DataGrid>
                            </div>
                            <div class="phantrang">
                                <div style="float: left; width: 100%">
                                    <div class="sotrang">
                                        <div style="margin-left: 10px; float: right;">
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
                                                <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                                <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                                <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                                <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                                <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                                <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                        <div style="float: right;">
                                            <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </td>
                    </tr>

                </table>
            </div>
        </div>
    </div>
    <script>
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
    <style>
        .table2 .chosen-disabled {
            opacity: 0.9 !important;
        }

            .table2 .chosen-disabled .chosen-single {
                background: none;
                background-color: #e3e3e3;
                border: solid 1px #cccccc;
                color: #044271;
            }
    </style>
</asp:Content>
