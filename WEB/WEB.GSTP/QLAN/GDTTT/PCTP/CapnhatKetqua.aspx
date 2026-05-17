<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="CapnhatKetqua.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.PCTP.CapnhatKetqua" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddCA_ID" runat="server" Value="0" />
    <asp:HiddenField ID="hddKetquaID" runat="server" Value="0" />
    <asp:HiddenField ID="hddLoaiToa" runat="server" Value="CAPHUYEN" />
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
    <div class="box">
        <div class="box_nd">
            <div class="boxchung">
                <h4 class="tleboxchung">Danh sách kết quả phân công thẩm phán</h4>
                <div class="boder" style="padding: 10px; min-height: 200px;">
                    <table class="table1">
                        <tr>
                            <td class="DonGDTCol1">Người gửi</td>
                            <td class="DonGDTCol2">
                                <asp:TextBox ID="txtNguoigui" runat="server" CssClass="user" Width="222px" MaxLength="250"></asp:TextBox>
                            </td>
                            <td class="DonGDTCol3">Số BA/QĐ</td>
                            <td class="DonGDTCol4">
                                <asp:TextBox ID="txtSoQDBA" runat="server" CssClass="user" Width="152px" MaxLength="50"></asp:TextBox>
                            </td>
                            <td class="DonGDTCol5">Ngày BA/QĐ</td>
                            <td>
                                <asp:TextBox ID="txtNgayBAQD" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtNgayBAQD" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtNgayBAQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                        </tr>
                        <tr>
                            <td>Tòa ra BA/QĐ</td>
                            <td>
                                <asp:DropDownList ID="ddlToaXetXu" CssClass="chosen-select" runat="server" Width="230px"></asp:DropDownList></td>
                            <td>Số thụ lý</td>
                            <td>
                                <asp:TextBox ID="txtThuly_So" runat="server" CssClass="user" Width="152px" MaxLength="250"></asp:TextBox>
                            </td>
                            <td>Ngày thụ lý</td>
                            <td>
                                <asp:TextBox ID="txtThuly_Ngay" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender11" runat="server" TargetControlID="txtThuly_Ngay" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender11" runat="server" TargetControlID="txtThuly_Ngay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                        </tr>
                        <tr>
                            <td>Thẩm phán
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlThamphan" CssClass="chosen-select" runat="server" Width="230px">
                                </asp:DropDownList>
                            </td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td align="left" colspan="5">
                                <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="cmdTimkiem_Click" />
                                <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_Click" />
                                <asp:Button ID="cmdQuaylai" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="cmdQuaylai_Click" />

                            </td>
                        </tr>
                        <tr>
                            <td colspan="6">
                                <asp:Label ID="lblThongbao" runat="server" ForeColor="Red"></asp:Label>
                            </td>
                        </tr>
                    </table>
                    <div>
                    </div>
                    <div style="width: 97%; padding: 5px; text-align: center; float: left;">
                    </div>

                    <div class="phantrang">
                        <div class="sobanghi">
                            <div style="float: left;">
                                <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu sửa đổi" OnClick="cmdUpdate_Click" />
                            </div>
                            <div style="float: left; padding-left: 5px;">
                                <asp:Button ID="btnNBInDSTP" runat="server" Width="128px" Height="30px" CssClass="buttoninput" Text="In DS TP giải quyết" OnClick="btnNBInDSTP_Click" />
                            </div>
                        </div>
                        <div class="sotrang">
                            <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                            &nbsp;&nbsp;
                                    <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
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
                            <asp:DropDownList ID="ddlPageCount" runat="server" Width="55px" CssClass="so" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount_SelectedIndexChanged">
                                <asp:ListItem Value="10" Text="10" Selected="True"></asp:ListItem>
                                <asp:ListItem Value="20" Text="20"></asp:ListItem>
                                <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                <asp:ListItem Value="500" Text="500"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                        PageSize="10" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages" OnItemDataBound="dgList_ItemDataBound" OnItemCreated="dgList_ItemCreated"
                        CssClass="table2" OnItemCommand="dgList_ItemCommand" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le" ItemStyle-CssClass="chan">
                        <Columns>
                            <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                            <asp:TemplateColumn HeaderStyle-Width="30px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                <HeaderTemplate>Chọn</HeaderTemplate>
                                <ItemTemplate>
                                    <asp:HiddenField ID="hddCurrID" runat="server" Value='<%#Eval("ID")%>' />
                                    <asp:HiddenField ID="hddCurrISTPB3" runat="server" Value='<%#Eval("ISTPB3")%>' />
                                    <asp:CheckBox ID="chkChon" runat="server" AutoPostBack="true" ToolTip='<%#Eval("ID")%>' OnCheckedChanged="chkChon_CheckedChanged" />
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" Width="30px"></HeaderStyle>
                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-Width="25px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                <HeaderTemplate>STT</HeaderTemplate>
                                <ItemTemplate><%#Eval("STT") %></ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:BoundColumn DataField="TL_SO" HeaderText="Số thụ lý" HeaderStyle-Width="45px" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                            <asp:BoundColumn DataField="TL_NGAY" HeaderText="Ngày thụ lý" HeaderStyle-Width="65px" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Top">
                                <HeaderTemplate>Thông tin người gửi</HeaderTemplate>
                                <ItemTemplate>
                                    <b><%#Eval("NGUOIGUI_HOTEN") %></b><br />
                                    <%#Eval("Diachigui") %>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                <ItemStyle HorizontalAlign="Left"></ItemStyle>
                            </asp:TemplateColumn>

                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="250px" ItemStyle-VerticalAlign="Top">
                                <HeaderTemplate>Thông tin BA/QĐ đề nghị GĐT,TT</HeaderTemplate>
                                <ItemTemplate>
                                    <b><%#Eval("BAQD") %></b> <i>Ngày: <b><%# GetDate(Eval("BAQD_NGAYBA")) %></b></i>
                                    &nbsp;<b><%#Eval("TOAXX_VietTat") %></b><br />
                                    <i><%# Convert.ToInt32(Eval("BAQD_CAPXETXU"))==4 ? ((String.IsNullOrEmpty(Eval("BAQD_SO_PT")+"")? "": "<hr  style='border-bottom: 0.5px dotted #808080;'>" + Eval("Infor_PT")+"<br/>") +
                                                        "<hr style='border-bottom: 0.5px dotted #808080;'>" +        
                                                        (String.IsNullOrEmpty(Eval("BAQD_SO_ST")+"")? "": Eval("Infor_ST") + "<br/>")):"" %></i>
                                    <i><%# Convert.ToInt32(Eval("BAQD_CAPXETXU"))==3 ? (String.IsNullOrEmpty(Eval("BAQD_SO_ST")+"")? "": "<hr style='border-bottom: 0.5px dotted #808080;'>" + Eval("Infor_ST") + "<br/>"):""%></i>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                            </asp:TemplateColumn>

                            <asp:TemplateColumn ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="80px">
                                <HeaderTemplate>Ngày phân công (HT)</HeaderTemplate>
                                <ItemTemplate>
                                    <asp:TextBox ID="txtNgayPhanCongTP" runat="server" CssClass="user" Width="80px"
                                        MaxLength="10" placeholder="..../..../....." Text='<%#Eval("NGAYPHANCONGTP") %>'></asp:TextBox>
                                    <cc1:CalendarExtender ID="CE_PCTP" runat="server" TargetControlID="txtNgayPhanCongTP" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="ME__PCTP" runat="server" TargetControlID="txtNgayPhanCongTP" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    <asp:HiddenField ID="hddNGAYTP" runat="server" Value='<%#Eval("NGAYPHANCONGTP") %>' />

                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" Width="80px"></HeaderStyle>
                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                            </asp:TemplateColumn>

                            <asp:TemplateColumn HeaderStyle-Width="150px" ItemStyle-HorizontalAlign="Left" HeaderStyle-HorizontalAlign="Center">
                                <HeaderTemplate>Thẩm phán</HeaderTemplate>
                                <ItemTemplate>
                                    <asp:Literal ID="lttTP" runat="server" Text='<%#Eval("TenThamPhan") %>'></asp:Literal>
                                    <asp:DropDownList CssClass="chosen-select" ID="ddlThamphan" runat="server" Width="150px"
                                        AutoPostBack="true" OnSelectedIndexChanged="dropThamPhan_SelectedIndexChanged">
                                    </asp:DropDownList>
                                    <asp:HiddenField ID="hddTPID" runat="server" Value='<%#Eval("CANBOID") %>' />
                                    <asp:HiddenField ID="hddTPIDSua" runat="server" Value='<%#Eval("CANBOID_SUA") %>' />
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" Width="150px"></HeaderStyle>
                                <ItemStyle HorizontalAlign="Left"></ItemStyle>
                            </asp:TemplateColumn>

                            <asp:TemplateColumn HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left">
                                <HeaderTemplate>Ghi chú</HeaderTemplate>
                                <ItemTemplate>
                                    <asp:TextBox ID="txtGhichu" runat="server" Text='<%# Eval("GHICHU")%>' CssClass="user" Width="150px" TextMode="MultiLine" Rows="2"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateColumn>

                            <asp:TemplateColumn ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="50px">
                                <HeaderTemplate>Số tờ trình</HeaderTemplate>
                                <ItemTemplate>
                                    <asp:TextBox ID="txtSoTT" runat="server" Text='<%# Eval("CD_SOTOTRINH")%>' CssClass="user" Width="50px" MaxLength="250"></asp:TextBox>
                                </ItemTemplate>

                                <HeaderStyle HorizontalAlign="Center" Width="50px"></HeaderStyle>
                                <ItemStyle HorizontalAlign="Left"></ItemStyle>
                            </asp:TemplateColumn>

                            <asp:TemplateColumn ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="80px">
                                <HeaderTemplate>Ngày tờ trình</HeaderTemplate>
                                <ItemTemplate>
                                    <asp:TextBox ID="txtNgayToTrinh" runat="server" CssClass="user" Width="80px"
                                        MaxLength="10" placeholder="..../..../....." Text='<%# Eval("CD_NGAYTOTRINH")%>'></asp:TextBox>
                                    <cc1:CalendarExtender ID="CE_TT" runat="server" TargetControlID="txtNgayToTrinh" Format="dd/MM/yyyy" Enabled="true" PopupPosition="left" />
                                    <cc1:MaskedEditExtender ID="ME__TT" runat="server" TargetControlID="txtNgayToTrinh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" Width="80px"></HeaderStyle>
                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
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
                            <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active" Visible="true"
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
                            <asp:DropDownList ID="ddlPageCount2" runat="server" Width="55px" CssClass="so" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount2_SelectedIndexChanged">
                                <asp:ListItem Value="10" Text="10" Selected="True"></asp:ListItem>
                                <asp:ListItem Value="20" Text="20"></asp:ListItem>
                                <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                <asp:ListItem Value="500" Text="500"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>


            </div>

        </div>

        <script type="text/javascript">
            function pageLoad(sender, args) {

                var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                for (var selector in config) { $(selector).chosen(config[selector]); }
            }

        </script>
</asp:Content>
