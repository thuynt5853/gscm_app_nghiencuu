<%@ Page Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="DonChoXuLy.aspx.cs" Inherits="WEB.GSTP.QLAN.DONCHOXULY.DonChoXuLy" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <style>
        .btnDCXL{
            font-weight: bold;
            color: #631313;
            background-color: #f5f6fa;
            padding: 2px 15px;
            cursor: pointer;
            border: solid 1px #c9bfbf;
            border-radius: 3px 3px 3px 3px;
            font-size: 11px;
        }
        .divDCXL{
            margin-top: 6px;
            margin-bottom: 6px;
        }
        .buttoninputCus{
            min-width: 50px;
            height: 25px;
            font-weight: bold;
            color: #631313;
            padding-left: 15px;
            padding-right: 15px;
            cursor: pointer;
            border: solid 1px #9e9e9e;
            border-radius: 3px 3px 3px 3px;
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
                                            <td>
                                                <div style="float: left; width: 1050px; display: flex; align-items: center;">
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Nguồn đến</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="ddlNguonDen" CssClass="chosen-select" runat="server" Width="248px">
                                                            <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
                                                            <asp:ListItem Value="1" Text="Bưu điện"></asp:ListItem>
                                                            <asp:ListItem Value="2" Text="Tiếp công dân"></asp:ListItem>
                                                            <asp:ListItem Value="3" Text="Trực tiếp"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                    <div style="float: left; width: 100px; text-align: right; margin-right: 10px;">Người gửi đơn/ Đương sự</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtNguoiGuiDon" CssClass="user" runat="server" Width="240px"></asp:TextBox>
                                                    </div>
                                                    <div style="float: left; width: 95px; text-align: right; margin-right: 10px;">Loại án</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="ddlLoaiAn" CssClass="chosen-select" runat="server" Width="248px">
                                                            <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
                                                            <asp:ListItem Value="1" Text="Hình sự"></asp:ListItem>
                                                            <asp:ListItem Value="2" Text="Dân sự"></asp:ListItem>
                                                            <asp:ListItem Value="3" Text="Hôn nhân và gia đình"></asp:ListItem>
                                                            <asp:ListItem Value="3" Text="Kinh doanh, thương mại"></asp:ListItem>
                                                            <asp:ListItem Value="5" Text="Lao động"></asp:ListItem>
                                                            <asp:ListItem Value="6" Text="Hành chính"></asp:ListItem>
                                                            <asp:ListItem Value="7" Text="Phá sản"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div style="float: left; width: 1050px; margin-top: 8px;">  
                                                    <div style="float: left; width: 358px;">
                                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px; margin-top: 5px;">Số lượng đơn</div>
                                                        <div style="float: left;">
                                                            <asp:TextBox ID="txtSoLuongDon" CssClass="user" runat="server" Width="240px"></asp:TextBox>
                                                        </div>
                                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px; margin-top: 13px;">Số đến từ</div>
                                                        <div style="float: left; margin-top: 8px;">
                                                            <asp:TextBox ID="txtSoDenTu" CssClass="user" runat="server" Width="238px"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                    <div style="float: left; width: 352px;">
                                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px; margin-top: 5px;"">Loại đơn</div>
                                                        <div style="float: left;">
                                                            <asp:DropDownList ID="ddlLoaiDon" CssClass="chosen-select" runat="server" Width="248px">
                                                                <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
                                                                <asp:ListItem Value="1" Text="Đơn khởi kiện"></asp:ListItem>
                                                                <asp:ListItem Value="2" Text="Đơn kháng cáo"></asp:ListItem>
                                                                <asp:ListItem Value="3" Text="Đơn khác"></asp:ListItem>
                                                            </asp:DropDownList>
                                                        </div>
                                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px; margin-top: 13px;">Đến</div>
                                                        <div style="float: left; margin-top: 8px;">
                                                            <asp:TextBox ID="txtDen" CssClass="user" runat="server" Width="240px"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                    <div style="float: left; width: 340px">
                                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Nội dung đơn</div>
                                                        <div style="float: left;">
                                                            <asp:TextBox ID="txtNoiDung" TextMode="multiline" Rows="3" CssClass="user" runat="server" Width="240px" Height="44px"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div style="float: left; width: 1050px; margin-top: 8px; display: flex; align-items: center;">
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Loại ngày</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="ddlLoaiNgay" CssClass="chosen-select" runat="server" Width="248px">
                                                            <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
                                                            <asp:ListItem Value="1" Text="Ngày nhập"></asp:ListItem>
                                                            <asp:ListItem Value="2" Text="Ngày đến"></asp:ListItem>
                                                            <asp:ListItem Value="3" Text="Ngày trên bì thư"></asp:ListItem>
                                                            <asp:ListItem Value="4" Text="Ngày chuyển"></asp:ListItem>
                                                            <asp:ListItem Value="5" Text="Ngày nhận"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                    <div style="float: left; width: 100px; text-align: right; margin-right: 10px;">Từ ngày </div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtTuNgay" runat="server" CssClass="user" Width="240px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="txtTuNgay_CalendarExtender" runat="server" TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                        <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtTuNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: right;margin-right: 10px;">Đến ngày</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" Width="240px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                        <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtDenNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 0px;"></cc1:MaskedEditValidator>
                                                    </div>
                                                </div>
                                                <div style="float: left; width: 1050px; margin-top: 8px; display: flex; align-items: center;">
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Trạng thái xử lý</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="ddlTrangThaiXuLy" CssClass="chosen-select" runat="server" Width="248px">
                                                            <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
                                                            <asp:ListItem Value="1" Text="Chưa xử lý"></asp:ListItem>
                                                            <asp:ListItem Value="2" Text="Đã tiếp nhận"></asp:ListItem>
                                                            <asp:ListItem Value="0" Text="Đã trả lại"></asp:ListItem>
                                                            <asp:ListItem Value="5" Text="Đã thu hồi"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>                                                
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </td>
                    </tr>

                    <tr>
                        <td align="center">
                            <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                            <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_Click" />
                        </td>
                    </tr>    
                    <tr>
                        <td>
                            <div style="float: left; width: 1050px; margin-bottom: -9px; margin-top:40px; display: flex; align-items: center;">
                                <div style="float: left; width: 45px; text-align: left; margin-right: 10px;">Ngày<span class="must_input">(*)</span></div>
                                <div style="float: left;">
                                    <asp:TextBox ID="txtNgayTra" runat="server" CssClass="user" Width="80px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgayTra" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgayTra" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    <cc1:MaskedEditValidator ID="MaskedEditValidator3" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayTra" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                </div>
                                <div style="float: left; width: 60px; text-align: left; margin-right: 10px;">Ghi chú<span class="must_input">(*)</span></div>
                                <div style="float: left;">
                                    <asp:TextBox ID="txtGhiChu" CssClass="user" runat="server" Width="240px"></asp:TextBox>
                                </div>
                                <div style="float: left; width: 95px; text-align: left; margin-left: 20px;">
                                    <asp:Button ID="cmdTraLai" runat="server" CssClass="buttoninputCus" Text="Trả lại" OnClick="cmdTraLai_Click"/>
                                </div>
                                <div style="float: left;">
                                    <asp:Label runat="server" ID="lbThongbao" ForeColor="Red" Font-Size="13px"></asp:Label>
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
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
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
                            </div>
                            <div>
                                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%"
                                    OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                    <Columns>
                                        <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="15px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate></HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkTraLai" AutoPostBack="true" ToolTip='<%#Eval("ID")%>' runat="server" />
                                                <asp:HiddenField ID="hdID" runat="server" Value='<%# Eval("ID_VBDH") %>' />
                                                <asp:HiddenField ID="hdID_DGN" runat="server" Value='<%# Eval("ID") %>' />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="15px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>STT</HeaderTemplate>
                                            <ItemTemplate><%#Eval("STT")%></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="100px" ItemStyle-HorizontalAlign="Justify">
                                            <HeaderTemplate>
                                                Loại đơn
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("LOAIDON")%>
                                                <asp:HiddenField ID="hdLoaiDon" runat="server" Value='<%#Eval("LOAIDON")%>' />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="80px" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Loại án
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("LOAIAN")%>
                                                <asp:HiddenField ID="hdLoaiAn" runat="server" Value='<%#Eval("LOAIAN")%>' />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Số/ngày đến
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                Số: <b><%#Eval("SODEN")%></b>
                                                <br /><%# string.Format("{0:dd/MM/yyyy}",Eval("NGAYDEN")) %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify">
                                            <HeaderTemplate>
                                                Người gửi đơn
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("NGUOIGUI")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify">
                                            <HeaderTemplate>
                                                Nội dung đơn
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("NOIDUNGDON")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Số lượng đơn
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("SLDON")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="80px" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Trạng thái
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("TRANGTHAI")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <%--<asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Lịch sử
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:ImageButton ID="lblLichSu" runat="server" ImageUrl="~/UI/img/history.png"
                                                    CausesValidation="false" CommandName="LichSu"
                                                    CommandArgument='<%#Eval("ID_VBDH") %>' ToolTip="Lịch sử"></asp:ImageButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>--%>
                                        <asp:TemplateColumn HeaderStyle-Width="90px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thao tác
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <div class="divDCXL">
                                                    <asp:LinkButton CssClass="btnDCXL" ID="lblChiTiet" runat="server" Text="Chi tiết" Style="padding-left: 20px; padding-right: 26px;"
                                                    CausesValidation="false" CommandName="ChiTiet"
                                                    CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                </div>
                                                <div class="divDCXL">
                                                    <asp:LinkButton CssClass="btnDCXL" ID="lbtTiepNhan" runat="server" Text="Tiếp nhận"
                                                    CausesValidation="false" CommandName="TiepNhan"
                                                    CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                </div>
                                                <div class="divDCXL">
                                                    <asp:LinkButton CssClass="btnDCXL" ID="lbtGhepDon" runat="server" Text="Ghép đơn" 
                                                    CausesValidation="false" CommandName="GhepDon"
                                                    CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                </div>
                                                <div class="divDCXL">
                                                    <asp:LinkButton CssClass="btnDCXL" ID="lblLichSu" runat="server" Text="Lịch sử" Style="padding-left: 23px; padding-right: 20px;"
                                                    CausesValidation="false" CommandName="LichSu"
                                                    CommandArgument='<%#Eval("ID_VBDH") %>'></asp:LinkButton>
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
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
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
</asp:Content>


