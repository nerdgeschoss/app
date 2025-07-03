import { Collapse } from '@nerdgeschoss/shimmer-component-collapse';
import { type ReactElement } from 'react';
import { Spacer } from '../spacer/spacer';
import { Text } from '../text/text';
import { getErrorMessage } from '../../util/errors';
import { useTranslate } from '../../util/dependencies';

export function FormError({
  touched,
  errors,
}: {
  touched?: boolean;
  errors?: string[];
}): ReactElement {
  const t = useTranslate();

  return (
    <Collapse open={touched && !!errors?.length}>
      <Spacer size={8} />
      <div className="text-field__errors">
        {errors?.map((error) => (
          <Text key={error}>{t(getErrorMessage(error))}</Text>
        ))}
      </div>
    </Collapse>
  );
}
