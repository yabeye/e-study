import { Roles, ReportStatus } from './enums.js';

// About
export const APP_NAME = 'E-Study';
export const APP_DESCRIPTION = 'A nodejs backend app for E-Study.';

// Status Codes
export const _200_SUCCESS = '200 Success';
export const _201_CREATED = '201 Created';
export const _400_BAD_REQUEST = '400 Bad Request';
export const _401_UNAUTHORIZED = '401 Unauthorized';
export const _403_FORBIDDEN = '403 Forbidden';
export const _404_NOT_FOUND = '404 Not Found';
export const _500_INTERNAL_SERVER_ERROR = '500 Internal Server Error';

// Error Messages
export const INVALID_ROUTE = 'Invalid Route';
export const NO_TOKEN_PROVIDED = 'No token  provided';
export const ONLY_ADMINS_CAN_ACCESS_THIS_ROUTE =
  'Only admins can access this route';

// User
export const ALL_ROLES = [
  Roles.Guest,
  Roles.User,
  Roles.Moderator,
  Roles.Admin,
];
export const DEFAULT_ROLE = Roles.User;

export const ALL_REPORTS = [
  ReportStatus.Spam,
  ReportStatus.Violence,
  ReportStatus.Abuse,
  ReportStatus.PersonalDetails,
  ReportStatus.AdultContents,
  ReportStatus.Others,
];

// Questions  and Answers
